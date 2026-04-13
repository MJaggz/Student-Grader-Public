class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_admin, only: [:destroy, :destroy_all, :reload]
  before_action :set_course, only: [:edit, :update, :destroy]
  include Pagy::Backend

  def index
    # 1. Setup Sorting
    allowed_columns = ["subject", "catalog_number", "title", "campus", "academic_career"]
    sort_column = allowed_columns.include?(params[:sort]) ? params[:sort] : "catalog_number"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    # 2. Get Filter Data for the Sidebar/Dropdowns
    @course_number_levels = (1..5).map { |level| "#{level}xxx" }
    cse_courses = Course.cse_subject
    @all_terms = Section.joins(:course).merge(cse_courses).where.not(term: [nil, ""]).distinct.order(:term).pluck(:term)
    @all_campuses = cse_courses.distinct.order(:campus).pluck(:campus)
    @all_careers = cse_courses.distinct.order(:academic_career).pluck(:academic_career)
    @catalog_empty = !cse_courses.exists?

    # 3. Apply Filters and Sort
    @courses = cse_courses
    if params[:catalog_number].present?
      if params[:catalog_number].match?(/\A[1-5]xxx\z/)
        selected_level = params[:catalog_number][0]
        @courses = @courses.where("catalog_number LIKE ?", "#{selected_level}%")
      else
        @courses = @courses.where(catalog_number: params[:catalog_number])
      end
    end
    @courses = @courses.offered_in_term(params[:term]) if params[:term].present?
    @courses = @courses.where(campus: params[:campus]) if params[:campus].present?
    @courses = @courses.where(academic_career: params[:academic_career]) if params[:academic_career].present?
    
    @courses = @courses.includes(:sections).order("#{sort_column} #{sort_direction}")
    @pagy, @courses = pagy(@courses, items: 10)
  end

  def reload
    # Filter out empty strings from the form
    api_params = params.permit(:q, :term, :campus, :"academic-career", :"catalog-number", :"instruction-mode").to_h.compact_blank
    
    count = Course.reload_from_api(api_params)

    if count > 0
      redirect_to courses_path, notice: "Successfully synced #{count} courses from OSU!"
    else
      redirect_to courses_path, alert: "No courses found. Try widening your search filters."
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to courses_path, notice: "Course removed from local database."
  end

  def destroy_all
    Course.destroy_all
    redirect_to courses_path, notice: "Local catalog cleared."
  end

  def edit
  end

  def update
    if @course.update(course_params)
      
      redirect_to courses_path, notice: "Course was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

private

def course_params
  params.require(:course).permit(
    :title, 
    :subject, 
    :catalog_number, 
    :units, 
    :description, 
    :academic_career, 
    :academic_group, 
    :campus, 
    :component
  )
end
  def confirm_admin
    redirect_to root_path, alert: "Access denied: Admins only." unless current_user&.admin?
  end
end
