require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe 'methods' do
    let(:order_item) { create(:order_item) }

    it 'should have a valid factory' do
      expect(order_item).to be_valid
    end
  end
end
