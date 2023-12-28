class CreateUserActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :user_activities do |t|

      t.references :user, foreign_key: true
      t.string :action
      t.datetime :timestamp
      t.timestamps
    end
  end
end
