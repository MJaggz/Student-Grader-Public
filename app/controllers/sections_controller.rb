class SectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:course_id]
      # Find the specific course first
      @course = Course.find(params[:course_id])
      # Get only sections for that course
      @sections = @course.sections.order(term: :desc, class_number: :asc)
    else
      # Fallback: show all sections if no course_id is provided
      @sections = Section.order(term: :desc, class_number: :asc)
    end

    # Optional: Add pagination if you have many sections
    # @pagy, @sections = pagy(@sections, items: 10)
  end

  def show
    @section = Section.find(params[:id])
  end
end
