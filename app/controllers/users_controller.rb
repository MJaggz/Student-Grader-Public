class UsersController < ApplicationController
  before_action :authenticate_user!

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
end