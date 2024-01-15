require 'rails_helper'

RSpec.describe CartController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:cart) { create(:cart, user_id: user.id, product_id: product.id) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'should assigns the users carts and renders the index template' do
      get :index
      expect(assigns(:carts)).to eq([cart])
      expect(response).to render_template(:index)
    end
  end


  describe 'POST #add_to_cart' do
    it 'should adds a product to the users\'s cart and redirects to root_path with success flash' do
      post :add_to_cart, params: { id: product.id }
      expect(flash[:success]).to be_present
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to(root_path)
    end

    it 'should handles failure to add a product to the cart and redirects to root_path with error flash' do
      allow(Cart).to receive(:current_user_cart).and_return(nil)
      post :add_to_cart, params: { id: product.id }
      expect(flash[:success]).to be_nil
      expect(flash[:error]).to be_present
      expect(response).to redirect_to(root_path)
    end
  end


  describe 'DELETE #delete_cart' do
    it 'should deletes the cart item and redirects to my_cart_path with success flash' do
      get :delete_cart, params: { id: cart.id }
      expect(Cart.exists?(cart.id)).to be_falsey
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(my_cart_path)
    end
  end


  describe 'GET #checkout' do
    it 'should assigns users information and renders the checkout template' do
      get :checkout
      expect(assigns(:carts)).to eq([cart])
      expect(assigns(:user)).to eq(user)
      expect(assigns(:order)).to be_a_new(Order)

      expect(response).to render_template(:checkout)
    end
  end


end
