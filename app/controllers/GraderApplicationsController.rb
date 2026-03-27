class GraderApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: [:show, :edit, :update]

  def show
    # If they don't have an application yet, send them to create one
    redirect_to new_grader_application_path if @application.nil?
  end

  def new
    # Prevent duplicates: if it exists, send to edit
    if current_user.grader_application.present?
      redirect_to edit_grader_application_path
      return
    end

    @application = current_user.build_grader_application
    # Build 3 empty availability slots for the form by default
    3.times { @application.availabilities.build }
  end

  def create
    @application = current_user.build_grader_application(application_params)
    if @application.save
      redirect_to grader_application_path, notice: "Application submitted successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @application is set by before_action
  end

  def update
    if @application.update(application_params)
      redirect_to grader_application_path, notice: "Application updated for the new semester!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = current_user.grader_application
  end

  def application_params
    params.require(:grader_application).permit(
      :phone_number, :expected_graduation,
      course_ids: [], # This array captures all the checkboxes for courses
      availabilities_attributes: [:id, :day, :start_time, :end_time, :_destroy]
    )
  end
end