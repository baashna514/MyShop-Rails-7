class PasswordResetMailer < ApplicationMailer

  def password_reset_email(user)
    @user = user
    @token = user.reset_password_token
    mail(to: @user.email, subject: "Password Reset")
  end
end
