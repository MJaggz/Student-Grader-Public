require 'httparty'

class UsersController < ApplicationController
  before_action :authenticate_user!

  include HTTParty

  def index
    @users = User.all
  end

  def approve
    @user = User.find(params[:id])
    if @user.update(approved: true)
      redirect_to users_list_path, notice: "User approved successfully."
    else
      redirect_to users_list_path, alert: "Failed to approve user."
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      redirect_to users_list_path, alert: "Cannot delete an admin user."
      return
    end
    if @user.destroy
      redirect_to root_path, notice: "User deleted successfully."
    else
      redirect_to users_list_path, alert: "Failed to delete user."
    end
  end
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