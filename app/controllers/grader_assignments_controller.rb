class GraderAssignmentsController < ApplicationController
  def index
    @grader_request = GraderRequest.find(params[:grader_request_id])
    @section = @grader_request.section
    @grader_assignments = @section.grader_assignments.includes(grader_application: :user)
    @grader_applications = GraderApplication.includes(:user)
    @assigned_application_ids = @grader_assignments.pluck(:grader_application_id)
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

    redirect_back fallback_location: grader_request_grader_assignments_path(@grader_request),
                  notice: "Grader assignment removed."
  end

  private

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
