class UserController < ApplicationController
  before_action :require_user_authentication, only: [:logout, :profile, :edit_profile, :update_profile]

  def user_login
    render 'user/login'
  end

  def check_credentials
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      UserActivityLoggerJob.perform_later(user.id, 'Login Action')
      flash[:success] = "Welcome back, #{user.name}!"
      if user.admin
        redirect_to admin_dashboard_path
      else
        redirect_to root_path
      end
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to login_path
    end
  end

  def logout
    UserActivityLoggerJob.perform_later(session[:user_id], 'Logout Action')
    session[:user_id] = nil
    flash[:success] = 'You have been logged out successfully!'
    redirect_to root_path
  end

  def profile
    @user = current_user
    @orders = @user.orders.includes(order_items: [:product])
    render 'user/profile'
  end

  def edit_profile
    @user = User.get_user_from_session(session)
    render 'user/edit'
  end

  def update_profile
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile was successfully updated.'
      redirect_to user_profile_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to edit_profile_path
    end
  end

  def sign_up_form
    @user = User.new
    render 'user/signup'
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Account was successfully created.'
      UserMailer.welcome_email(@user).deliver_now
      redirect_to login_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to sign_up_path
    end
  end


  # Password Reset Functions
  def new_password_reset
    render 'user/reset/new'
  end

  def create_password_reset
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token
      PasswordResetMailer.password_reset_email(user).deliver_now
      flash[:success] = "Password reset instructions sent to your email."
      redirect_to root_path
    else
      flash[:error] = "User not found with the provided email."
      redirect_to new_password_reset_path
    end
  end

  def edit_password_reset
    @user = User.find_by(reset_password_token: params[:token])
    unless @user && !@user.password_reset_expired?
      flash[:error] = "Invalid or expired password reset link."
      redirect_to new_password_reset_path
      return
    end
    render 'user/reset/edit_password_reset'
  end

  def update_password_reset
    @user = User.find_by(reset_password_token: params[:token])
    if @user && !@user.password_reset_expired? && @user.update(user_params)
      flash[:success] = "Password has been reset. You can now log in with your new password."
      redirect_to login_path
    else
      flash[:error] = "Invalid or expired password reset request."
      render 'user/reset/edit_password_reset'
    end
  end




  private
  def require_user_authentication
    unless user_authenticated?
      flash[:error] = 'You need to log in to perform this action.'
      redirect_to new_user_session_path
    end
  end

  def user_authenticated?
    user_signed_in?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :city, :address)
  end



end
