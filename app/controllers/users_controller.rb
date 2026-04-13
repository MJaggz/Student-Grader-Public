require "httparty"

class UsersController < ApplicationController
  before_action :only_admins, only: [ :index, :approve, :destroy ]

  include HTTParty

  def index
    @users = User.all
  end

  def approve
    @user = User.find(params[:id])
    if @user.update(approved: true)
      redirect_to users_path, notice: "User approved successfully."
    else
      redirect_to users_path, alert: "Failed to approve user."
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, notice: "User deleted successfully."
    else
      redirect_to users_path, alert: "Failed to delete user."
    end
  end

  # Only admins allowed!!!!
  def only_admins
    return if current_user && current_user.admin?
    redirect_to root_path, alert: "You must be an administrator to access this page."
  end
end
