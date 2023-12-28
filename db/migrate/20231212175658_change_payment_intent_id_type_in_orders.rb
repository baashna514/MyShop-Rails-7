class ChangePaymentIntentIdTypeInOrders < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :payment_intent_id, :string
  end

  def down
    change_column :orders, :payment_intent_id, :integer
  end
end
