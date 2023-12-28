require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  context '#order_email' do
    let(:order) { create(:order) }
    let(:mail) { described_class.order_email(order) }

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('Order Confirmation Email')
      expect(mail.to).to eq([order.email])
    end

    it 'renders the body correctly' do
      expect(mail.body.encoded).to match("Order Confirmation")
    end
  end
end