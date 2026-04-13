class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_approval
  include Pagy::Backend

  private

  def check_approval
    return if !user_signed_in? || current_user.student?
    if !current_user.approved?
      sign_out current_user
      redirect_to root_path, alert: "Your account is pending approval. Please wait for an administrator to approve your account before logging in."
    end
  end

  protected

  def configure_permitted_parameters
    # Permit :role for the sign_up action
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    # Permit :role for updating the account
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role ])
  end
end
