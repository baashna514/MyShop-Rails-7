class OrderMailJob < ApplicationJob
  queue_as :default

  def perform(order)
    OrderMailer.order_email(order).deliver_now
  end
end
