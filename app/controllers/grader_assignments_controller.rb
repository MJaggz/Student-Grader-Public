class GraderAssignmentsController < ApplicationController
  def index
    @grader_request = GraderRequest.find(params[:grader_request_id])
    @section = @grader_request.section
    @grader_assignments = @section.grader_assignments.includes(grader_application: :user)
    @assigned_application_ids = @grader_assignments.pluck(:grader_application_id)

    section_days = parse_section_days(@section.days)
    section_start_time, section_end_time = parse_section_times(@section.times)

    @grader_applications = GraderApplication
      .includes(:user, :courses, :availabilities)
      .select do |application|

        matches_course =
          application.courses.include?(@section.course)

       matches_availability =
          section_start_time.present? &&
          section_end_time.present? &&
          application.availabilities.any? do |availability|

            avail_start = availability.start_time.seconds_since_midnight
            avail_end   = availability.end_time.seconds_since_midnight

            section_start = section_start_time.seconds_since_midnight
            section_end   = section_end_time.seconds_since_midnight

            section_days.include?(availability.day) &&
              avail_start <= section_start &&
              avail_end >= section_end
          end
        matches_course && matches_availability
      end
  end

  def create
    @section = Section.find(grader_assignment_params[:section_id])
    @grader_application = GraderApplication.find(grader_assignment_params[:grader_application_id])

    @grader_assignment = GraderAssignment.new(
      section: @section,
      grader_application: @grader_application
    )

    if @grader_assignment.save
      update_request_assignment_count(@section)
      redirect_back fallback_location: grader_request_grader_assignments_path(@section.grader_request),
                    notice: "Grader assigned successfully."
    else
      redirect_back fallback_location: grader_request_grader_assignments_path(@section.grader_request),
                    alert: @grader_assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @grader_assignment = GraderAssignment.find(params[:id])
    @section = @grader_assignment.section
    @grader_request = @section.grader_request

    @grader_assignment.destroy
    update_request_assignment_count(@section)

    redirect_back fallback_location: assignments_list_path,
                  notice: "Grader assignment removed."
  end

  def assignments_list
    if current_user.admin? && params[:user_id].present?
      @user = User.find(params[:user_id])
      @grader_application = @user.grader_application
    else
      @user = current_user
      @grader_application = current_user.grader_application
    end

    if @grader_application.present?
      @grader_assignments = @grader_application
        .grader_assignments
        .includes(section: :course)
    else
      @grader_assignments = []
    end
  end

  private

  def parse_section_times(times_string)
    return [nil, nil] if times_string.blank?

    start_str, end_str = times_string.split(" to ")

    [
      Time.zone.parse(start_str),
      Time.zone.parse(end_str)
    ]
  end

  def parse_section_days(days_string)
    return [] if days_string.blank?

    map = {
      "M" => "Monday",
      "T" => "Tuesday",
      "W" => "Wednesday",
      "Th" => "Thursday",
      "F" => "Friday"
    }

    days_string.split.map { |day| map[day] }.compact
  end

  def grader_assignment_params
    params.require(:grader_assignment).permit(:section_id, :grader_application_id)
  end

  def update_request_assignment_count(section)
    return unless section.grader_request.present?

    assigned_count = section.grader_assignments.count
    request = section.grader_request

    request.update(
      num_graders_assigned: assigned_count,
      fulfilled_date: assigned_count >= request.num_graders_requested ? Time.current : nil
    )
  end
end