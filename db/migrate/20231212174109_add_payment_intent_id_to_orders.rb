class AddPaymentIntentIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_intent_id, :integer, default: nil
  end
end
