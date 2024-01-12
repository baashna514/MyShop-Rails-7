class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product


  def self.create_order_items(order, items)
    if items.count > 0
      items.each do |item|
        product = item.product
        item_details = {
          order_id: order.id,
          product_id: product.id,
          quantity: item.quantity,
          price: product.p_price
        }
        @row = OrderItem.new(item_details)
        if @row
          @row.save
        end
      end
    end
  end

end
