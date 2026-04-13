class NotificationsController < ApplicationController
  def index
    @users = User.all
    @grader_requests = GraderRequest.includes(section: :course)
  end
end