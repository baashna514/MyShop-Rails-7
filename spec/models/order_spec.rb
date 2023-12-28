require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
  end

  describe 'associations' do
    it { should have_many(:order_items) }
    it { should belong_to(:user) }
  end

  describe 'methods' do
    let(:user) { create(:user) }

    it 'should create a new order' do
      params = {
        name: 'Moin Abbas',
        phone: '03321773514',
        email: 'moin.abbas@example.com',
        address: 'Room#303, KEMU Doctors Hostel, Hall Road, Lahore, Pakistan',
        city: 'Lahore'
      }

      order = Order.create_order(user.id, params)
      expect(order).to be_an_instance_of(Order)
      expect(order.persisted?).to be true
    end

    it 'should send daily orders email' do
      order = create(:order, created_at: Time.current)
      expect(AdminMailer).to receive(:daily_order_summary).with([order]).and_return(double(deliver_now: true))
      Order.send_daily_orders_email
    end
  end
end
