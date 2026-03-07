# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admins, only: [:destroy, :fetch_courses, :destroy_all_courses, :update_courses]

def index
  @courses = Course.all
end

def destroy
  course = Course.find(params[:id])
  sections = Section.where(course_id: course.id)
  sections.destroy_all
  course.destroy
  redirect_to courses_path, notice: "Course deleted successfully."
end

def fetch_courses
  fetch_course_data({})
  redirect_to courses_path, notice: "Course data fetched and saved successfully."
end

def update_courses
  sync_courses_from_api({})
  redirect_to courses_path, notice: "Courses updated successfully."
rescue StandardError => e
  redirect_to courses_path, alert: "Failed to update courses: #{e.message}"
end

def destroy_all_courses
  Section.destroy_all
  Course.destroy_all
  redirect_to courses_path, notice: "All courses deleted successfully."
end

# Gets course data from API and saves it to the database
def fetch_course_data(queries)
  options = { query: {:'q'=> 'cse', :'client'=> 'class-search-ui', :'academic-career' => 'ugrd', :'term' => '1268', :'campus' => 'col'} }
  options[:query].merge!(queries)
  courses =  JSON.parse(HTTParty.get("https://contenttest.osu.edu/v2/classes/search", options).body)["data"]["courses"]

  courses.each do |course|
    Course.create(
      academic_career: course["course"]["academicCareer"],
      academic_group: course["course"]["academicGroup"],
      campus: course["course"]["campus"],
      catalog_number: course["course"]["catalogNumber"],
      component: course["course"]["component"],
      description: course["course"]["description"],
      subject: course["course"]["subject"],
      term: course["course"]["term"],
      title: course["course"]["title"],
      units: course["course"]["minUnits"]
    )

    sections = course["sections"]
    sections.each do |section|
      days = ""
      days += "M " if section["meetings"][0]["monday"]

      days += "T " if section["meetings"][0]["tuesday"]

      days += "W " if section["meetings"][0]["wednesday"]

      days += "Th " if section["meetings"][0]["thursday"]

      days += "F" if section["meetings"][0]["friday"]
      
      Section.create(
        class_number: section["classNumber"],
        course_id: Course.last.id,
        days: days,
        term: section["term"],
        times: "#{section["meetings"][0]["startTime"]} to #{section["meetings"][0]["endTime"]}"
      )
    end
  end

end

private

def only_admins
  return if current_user&.admin?

  redirect_to root_path, alert: "You must be an administrator to access this page."
end

def sync_courses_from_api(queries)
  api_courses = fetch_api_courses(queries)
  seen_course_ids = []

  api_courses.each do |api_course|
    course = upsert_course(api_course)
    seen_course_ids << course.id
    sync_sections_for_course(course, api_course["sections"] || [])
  end

  # Remove stale rows so the local catalog matches the API for this query.
  stale_courses = Course.where.not(id: seen_course_ids)
  Section.where(course_id: stale_courses.select(:id)).destroy_all
  stale_courses.destroy_all
end

def fetch_api_courses(queries)
  options = {
    query: {
      :'q'=> 'cse',
      :'client'=> 'class-search-ui',
      :'academic-career' => 'ugrd',
      :'term' => '1268',
      :'campus' => 'col'
    }
  }
  options[:query].merge!(queries)
  response = HTTParty.get("https://contenttest.osu.edu/v2/classes/search", options)
  JSON.parse(response.body).dig("data", "courses") || []
end

def upsert_course(api_course)
  data = api_course["course"] || {}
  course = Course.find_or_initialize_by(
    subject: data["subject"],
    catalog_number: data["catalogNumber"],
    term: data["term"],
    campus: data["campus"],
    component: data["component"]
  )

  course.update!(
    academic_career: data["academicCareer"],
    academic_group: data["academicGroup"],
    campus: data["campus"],
    catalog_number: data["catalogNumber"],
    component: data["component"],
    description: data["description"],
    subject: data["subject"],
    term: data["term"],
    title: data["title"],
    units: data["minUnits"]
  )
  course
end

def sync_sections_for_course(course, api_sections)
  seen_section_ids = []

  api_sections.each do |api_section|
    section = course.sections.find_or_initialize_by(class_number: api_section["classNumber"])
    section.update!(
      term: api_section["term"],
      days: format_days(api_section),
      times: format_times(api_section)
    )
    seen_section_ids << section.id
  end

  course.sections.where.not(id: seen_section_ids).destroy_all
end

def format_days(api_section)
  meeting = api_section.dig("meetings", 0) || {}
  days = []
  days << "M" if meeting["monday"]
  days << "T" if meeting["tuesday"]
  days << "W" if meeting["wednesday"]
  days << "Th" if meeting["thursday"]
  days << "F" if meeting["friday"]
  days.join(" ")
end

def format_times(api_section)
  meeting = api_section.dig("meetings", 0) || {}
  start_time = meeting["startTime"]
  end_time = meeting["endTime"]
  return nil if start_time.blank? || end_time.blank?

  "#{start_time} to #{end_time}"
end

end
