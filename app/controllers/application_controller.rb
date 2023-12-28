class ApplicationController < ActionController::Base
  before_action :capture_admin_status, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end

  def capture_admin_status
    @is_admin_before_sign_out = current_user.admin?
  end

  def after_sign_out_path_for(resource_or_scope)
    @is_admin_before_sign_out ? admin_login_path : root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :city, :address, :admin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :city, :address, :admin])
  end
end
