require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  describe 'daily_order_summary' do
    let(:orders) { FactoryBot.create_list(:order, 3) } # Assuming you have an Order factory

    it 'sends a daily order summary email' do
      mail = AdminMailer.daily_order_summary(orders)
      expect(mail.subject).to eq('Daily Orders Summary')
      expect(mail.to).to eq(['admin@gmail.com'])
    end
  end
end
