class AdminMailer < ApplicationMailer
  layout 'mailer'

  def daily_order_summary(orders)
    @orders = orders
    mail(to: 'admin@gmail.com', subject: 'Daily Orders Summary')
  end
end
