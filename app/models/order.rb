class Order < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true

  has_many :order_items
  belongs_to :user

  after_create :check_and_send_email

  def self.create_order(user_id, params)
    params[:order_date] = Time.current
    params[:user_id] = user_id
    params[:status] = 'pending'
    params[:payment_method] = 'cash on delivery'
    order = new(params)
    if order.save
      return order
    else
      return false
    end
  end


  def self.send_daily_orders_email
    orders = where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
    AdminMailer.daily_order_summary(orders).deliver_now
  end

  private
  def check_and_send_email
    if self.order_items.count
      OrderMailJob.perform_later(self)
    end
  end

end
