class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|

      t.string :p_name
      t.text :p_desc
      t.string :p_price
      t.string :p_image
      t.timestamps
    end
  end
end
