class AddUserIdToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :user_id, :integer, :default => nil
  end
end
