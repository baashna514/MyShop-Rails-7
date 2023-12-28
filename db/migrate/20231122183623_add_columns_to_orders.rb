class AddColumnsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :name, :string
    add_column :orders, :phone, :string
    add_column :orders, :username, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :text
    add_column :orders, :city, :string
    add_column :orders, :country, :string
    add_column :orders, :state, :string
    add_column :orders, :zip, :string
    add_column :orders, :payment_method, :string
  end
end
