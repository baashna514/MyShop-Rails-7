class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|

      t.date :order_date
      # t.integer :user_id
      t.decimal :total
      t.string :status
      t.timestamps
    end
  end
end
