class OrderMailer < ApplicationMailer
  layout 'mailer'

  def order_email(order)
    @order = order

    @order.order_items.each do |item|
      if item.product.p_image.attached?
        attachments.inline[item.product.p_image.filename.to_s] = item.product.p_image.download
      end
    end

    mail(to: @order.email, subject: 'Order Confirmation Email')
  end
end
