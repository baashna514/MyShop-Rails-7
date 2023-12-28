class AddColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :city, :string
    add_column :users, :address, :text
    add_column :users, :admin, :boolean
  end
end
