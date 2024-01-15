require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '.current_user_cart' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    context 'when the cart exists for the users and product' do
      it 'increments the quantity of the existing cart' do
        existing_cart = create(:cart, user_id: user.id, product_id: product.id, quantity: 2)
        expect do
          described_class.current_user_cart(user.id, product.id)
          existing_cart.reload
        end.to change { existing_cart.quantity }.by(1)
      end
    end

    context 'when the cart does not exist for the users and product' do
      it 'creates a new cart with quantity set to 1' do
        expect do
          described_class.current_user_cart(user.id, product.id)
        end.to change(Cart, :count).by(1)

        new_cart = Cart.last
        expect(new_cart.user_id).to eq(user.id)
        expect(new_cart.product_id).to eq(product.id)
        expect(new_cart.quantity).to eq(1)
      end
    end
  end



  describe '.cart_counter' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    context 'when the users has carts' do
      it 'returns the count of carts for the users' do
        create_list(:cart, 3, user_id: user.id, product_id: product.id)
        cart_count = described_class.cart_counter(user.id)
        expect(cart_count).to eq(3)
      end
    end

    context 'when the users has no carts' do
      it 'returns 0' do
        cart_count = described_class.cart_counter(user.id)
        expect(cart_count).to eq(0)
      end
    end
  end



  describe '.get_my_cart' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }
    let!(:cart1) { create(:cart, user_id: user.id, product_id: product.id) }
    let!(:cart2) { create(:cart, user_id: user.id, product_id: product.id) }

    it 'returns carts for the given user_id' do
      result = Cart.get_my_cart(user.id)
      expect(result).to include(cart1)
      expect(result).to include(cart2)
    end

    it 'does not return carts for other user_ids' do
      other_user = create(:user)
      other_product = create(:product)
      cart_for_other_user = create(:cart, user_id: other_user.id, product_id: other_product.id)
      result = Cart.get_my_cart(user.id)
      expect(result).not_to include(cart_for_other_user)
    end
  end

  describe '.get_cart_items' do
    let(:user) { create(:user) }
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }

    let!(:cart1) { create(:cart, user_id: user.id, product_id: product1.id) }
    let!(:cart2) { create(:cart, user_id: user.id, product_id: product2.id) }

    it 'returns cart items for the given user_id with associated products' do
      result = Cart.get_cart_items(user.id)

      expect(result).to include(cart1)
      expect(result).to include(cart2)
      expect(result.first.product).to eq(product1)
      expect(result.second.product).to eq(product2)
    end

    it 'does not return cart items for other user_ids' do
      other_user = create(:user)
      cart_for_other_user = create(:cart, user_id: other_user.id, product_id: create(:product).id)
      result = Cart.get_cart_items(user.id)
      expect(result).not_to include(cart_for_other_user)
    end
  end

end
