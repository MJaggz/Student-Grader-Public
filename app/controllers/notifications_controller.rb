class NotificationsController < ApplicationController
  def index
    @users = User.all
  end
end
