class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_approval


  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  def check_approval
    return if !user_signed_in? || current_user.student?
    if !current_user.approved?
      sign_out current_user
      redirect_to root_path, alert: "Your account is pending approval. Please wait for an administrator to approve your account before logging in."
    end
  end
end
