require 'rails_helper'

RSpec.describe PasswordResetMailer, type: :mailer do
  context '#password_reset_email' do
    let(:user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64) }
    let(:mail) { described_class.password_reset_email(user) }

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('Password Reset')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body correctly' do
      @token = user.reset_password_token
      expect(mail.body.encoded).to match("Click the link below to reset your password:")
      expect(mail.body.encoded).to match(edit_password_reset_url(@token))
    end
  end
end