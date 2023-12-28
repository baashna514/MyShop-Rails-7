require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:p_name) }
    it { should validate_presence_of(:p_desc) }
    it { should validate_presence_of(:p_price) }
  end

  describe 'associations' do
    it { should have_many(:carts) }
    it { should have_many(:order_items) }
    it { should have_one_attached(:p_image) }
  end

  describe 'methods' do
    let(:product) { create(:product) }
    let(:user) { create(:user) }

    it 'should check if the product has orders' do
      expect(product.has_orders?).to be false
    end

    it 'should check if the product has carts' do
      expect(product.has_carts?).to be false
    end

    it 'should check if the product is in use and cannot be deleted' do
      expect(product.has_orders?).to be false
      expect(product.has_carts?).to be false

      result, message = Product.check_product_use(product)
      expect(result).to be false
      expect(message).to be_nil
    end

    it 'should not allow deletion of a product with orders' do
      create(:order_item, product: product)

      result, message = Product.check_product_use(product)
      expect(result).to be true
      expect(message).to eq("You can't delete this product, it is already in use somewhere.")
    end

    it 'should not allow deletion of a product with carts' do
      create(:cart, product_id: product.id, user_id: user.id)
      result, message = Product.check_product_use(product)
      expect(result).to be true
      expect(message).to eq("You can't delete this product, it is already in use somewhere.")
    end
  end
end
