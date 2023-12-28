class OrderController < ApplicationController
  before_action :require_user_authentication

  def place_order
    order = Order.create_order(current_user.id, order_params)
    if order
      cart_items = Cart.get_cart_items(order.user_id)
      result = OrderItem.create_order_items(order, cart_items)
      if result
        Cart.where(user_id: current_user.id).destroy_all
        OrderMailer.order_email(order).deliver_now
        flash[:success] = "Order was successfully placed"
      else
        flash[:error] = "Order was not placed"
      end
      redirect_to root_path
    else
      flash[:error] = "Order was not placed"
      redirect_to checkout_path
    end
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

  def order_params
    params.require(:order).permit(:name, :phone, :username, :email, :address, :city, :country, :state, :zip)
  end
end
