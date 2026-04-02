class SectionsController < ApplicationController
  before_action :authenticate_user!

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
    @section = Section.find(params[:id])
  end
end
