class GraderRequestsController < ApplicationController
  def index
    @grader_requests = GraderRequest.includes(section: :course).order(request_date: :desc)
  end

  def show
    @grader_request = GraderRequest.find(params[:id])
    redirect_to grader_request_grader_assignments_path(@grader_request)
  end

  def create
    @section = Section.find(params[:section_id])

    if @section.grader_request.present?
      redirect_back fallback_location: course_sections_path(@section.course),
                    alert: "This section already has a grader request."
      return
    end

    @grader_request = @section.build_grader_request(grader_request_params)
    @grader_request.requestor_name = current_user.email
    @grader_request.request_date ||= Time.current
    @grader_request.request_number ||= generate_request_number(@section)
    @grader_request.num_graders_requested = @section.graders_required
    @grader_request.num_graders_assigned ||= 0

    if @grader_request.save
      redirect_back fallback_location: course_sections_path(@section.course),
                    notice: "Grader request submitted."
    else
      redirect_back fallback_location: course_sections_path(@section.course),
                    alert: @grader_request.errors.full_messages.to_sentence
    end
  end

  private

  def grader_request_params
    {}
  end

  def generate_request_number(section)
    "#{section.section_number}-#{SecureRandom.hex(3)}"
  end
end
