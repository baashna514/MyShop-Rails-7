class Cart < ApplicationRecord
  belongs_to :product

  def self.current_user_cart(user_id, product_id)
    cart = find_by(user_id: user_id, product_id: product_id)
    if cart
      cart.increment!(:quantity)
    else
      cart = Cart.create(user_id: user_id, product_id: product_id, quantity: 1)
    end
    cart
  end

  def self.cart_counter(user_id)
    where(user_id: user_id).count(:id)
  end

  def self.get_my_cart(user_id)
    Cart.where(user_id: user_id).includes(product: { p_image_attachment: :blob })
  end

  def self.get_cart_items(user_id)
    Cart.where(user_id: user_id).includes(:product)
  end

end
