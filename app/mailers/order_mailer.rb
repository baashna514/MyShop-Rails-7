class OrderMailer < ApplicationMailer
  layout 'mailer'

  def order_email(order)
    @order = order
    mail(to: @order.email, subject: 'Order Confirmation Email')
  end
end
