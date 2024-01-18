class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_oauth2('Google', 'devise.google_data')
  end
  def facebook
    handle_oauth2('Facebook', 'devise.facebook_data')
  end
  def github
    handle_oauth2('GitHub', 'devise.github_data')
  end
  def failure
    redirect_to root_path
  end



  private
  def handle_oauth2(provider, session_key)
    @result = User.from_omniauth(request.env['omniauth.auth'])
    if @result.is_a?(Hash)
      flash[:alert] = "Email has already been taken. Please log in or choose a different email."
      redirect_to new_user_session_path
    elsif @result.persisted?
      sign_in_and_redirect @result, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session[session_key] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
