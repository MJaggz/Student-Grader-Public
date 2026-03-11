class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_admin, only: [:destroy, :destroy_all, :reload]
  include Pagy::Backend

  def index
    # 1. Setup Sorting
    allowed_columns = ["subject", "catalog_number", "title", "term", "campus", "academic_career"]
    sort_column = allowed_columns.include?(params[:sort]) ? params[:sort] : "catalog_number"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    # 2. Get Filter Data for the Sidebar/Dropdowns
    @course_number_levels = (1..5).map { |level| "#{level}xxx" }
    @all_terms = Course.distinct.order(:term).pluck(:term)
    @all_campuses = Course.distinct.order(:campus).pluck(:campus)
    @all_careers = Course.distinct.order(:academic_career).pluck(:academic_career)
    @catalog_empty = !Course.exists?

    # 3. Apply Filters and Sort
    @courses = Course.all
    if params[:catalog_number].present?
      if params[:catalog_number].match?(/\A[1-5]xxx\z/)
        selected_level = params[:catalog_number][0]
        @courses = @courses.where("catalog_number LIKE ?", "#{selected_level}%")
      else
        @courses = @courses.where(catalog_number: params[:catalog_number])
      end
    end
    @courses = @courses.where(term: params[:term]) if params[:term].present?
    @courses = @courses.where(campus: params[:campus]) if params[:campus].present?
    @courses = @courses.where(academic_career: params[:academic_career]) if params[:academic_career].present?
    
    @courses = @courses.order("#{sort_column} #{sort_direction}")
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

  private

  def confirm_admin
    redirect_to root_path, alert: "Access denied: Admins only." unless current_user&.admin?
  end
end
