class AddUserIdToUserActivities < ActiveRecord::Migration[7.1]
  def change
    remove_reference :user_activities, :user, foreign_key: true
    add_column :user_activities, :user_id, :integer
  end
end
