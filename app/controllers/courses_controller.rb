# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  before_action :authenticate_user!

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

def destroy_all_courses
  Section.destroy_all
  Course.destroy_all
  redirect_to courses_path, notice: "All courses deleted successfully."
end

# Gets course data from API and saves it to the database
def fetch_course_data(queries)
  options = { query: {q: "cse", client: "class-search-ui", academiccareer: "UGRAD", term: "1268", campus: "col"} }
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

end