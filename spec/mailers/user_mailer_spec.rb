require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#welcome_email' do
    let(:user) { create(:user) }
    let(:mail) { described_class.welcome_email(user) }

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('New Registration Email')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body correctly' do
      expect(mail.body.encoded).to match("Welcome to Our Application, #{user.name}!")
    end
  end
end