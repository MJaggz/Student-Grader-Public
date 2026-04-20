class SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_section, only: [:show, :edit, :update]
  before_action :confirm_admin, only: [:edit, :update]

  def index
    if params[:course_id]
      @course = Course.find(params[:course_id])
      @available_terms = @course.sections.where.not(term: [nil, ""]).distinct.order(term: :desc).pluck(:term)
      @selected_term = params[:term].presence

      @sections = @course.sections
      @sections = @sections.with_term(@selected_term)
      @sections = @sections.ordered_for_catalog
    else
      @selected_term = params[:term].presence
      @sections = Section.with_term(@selected_term).ordered_for_catalog
    end
  end

  def show
  end

  def edit
  end

  def update
    if @section.update(section_params)
      redirect_to course_sections_path(@section.course, term: @section.term),
                  notice: "Section grader requirement updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:graders_required)
  end

  def confirm_admin
    redirect_to root_path, alert: "Access denied: Admins only." unless current_user&.admin?
  end
end
