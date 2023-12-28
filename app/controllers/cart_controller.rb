class CartController < ApplicationController
  before_action :require_user_authentication, only: [:add_to_cart, :index]

  def index
    @carts = Cart.get_my_cart(current_user.id)
  end

  def add_to_cart
    product = Product.find(params[:id])
    current_user_cart = Cart.current_user_cart(current_user.id, product.id)
    if current_user_cart
        flash[:success] = "#{product.p_name} added to the cart."
    else
        flash[:error] = "Failed to add #{product.p_name} to the cart."
    end
    redirect_back(fallback_location: root_path)
  end

  def delete_cart
    cart = Cart.find(params[:id])
    if cart
      cart.destroy
    end
    flash[:success] = "Item removed from cart."
    redirect_to my_cart_path
  end

  def checkout
    @carts = Cart.get_my_cart(current_user.id)
    @user = current_user
    @order = Order.new

    output = {
      name: "#{@user.first_name} #{@user.last_name}",
      phone: @user.phone,
      email: @user.email,
      address: @user.address,
      city: @user.city,
    }
    render 'cart/checkout', locals: {order: output}
  end



  private

  def require_user_authentication
    unless user_authenticated?
      flash[:error] = 'You need to log in to perform this action.'
      redirect_to new_user_session_path
    end
  end

  def user_authenticated?
    user_signed_in?
  end
end
