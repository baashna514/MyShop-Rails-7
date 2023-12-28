require 'rails_helper'

RSpec.describe OrderController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:valid_order_params) { attributes_for(:order) }

  before do
    session[:user_id] = user.id
  end

  describe 'POST #place_order' do
    context 'with valid order parameters' do
      it 'creates an order, sets success flash, and redirects to root_path' do
        @cart = create(:cart, user_id: user.id, product_id: product.id)
        post :place_order, params: { order: valid_order_params }
        expect(flash[:success]).to eq('Order was successfully placed')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid order parameters' do
      it 'does not create an order, sets error flash, and redirects to checkout_path' do
        post :place_order, params: { order: { invalid_param: 'invalid_value' } }
        expect(flash[:error]).to eq('Order was not placed')
        expect(response).to redirect_to(checkout_path)
      end
    end
  end
end
