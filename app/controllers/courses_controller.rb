# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  before_action :authenticate_user!

def index
  @courses = Course.all
end

# Moved into courses controller
# Gets course data from API and saves it to the database
def fetch_course_data(queries)
    @user = User.find(params[:id])
    if @user.admin?
      options = { query: {q: "cse", client: "class-search-ui", academiccareer: "ugrad"} }
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
      if section["meetings"]["monday"]
        days += "M "
      end

      if section["meetings"]["tuesday"]
        days += "T "
      end

      if section["meetings"]["wednesday"]
        days += "W "
      end

      if section["meetings"]["thursday"]
        days += "R "
      end

      if section["meetings"]["friday"]
        days += "F"
      end

        Section.create(
          class_number: section["classNumber"],
          course_id: section["courseId"],
          days: days,
          term: section["term"],
          times: "#{section["meetings"]["startTime"]} to #{section["meetings"]["endTime"]}"
        )
      end
      end
    end
    end
end