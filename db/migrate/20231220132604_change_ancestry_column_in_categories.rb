class ChangeAncestryColumnInCategories < ActiveRecord::Migration[7.1]
  def change
    change_column_default :categories, :ancestry, nil
    change_column_null :categories, :ancestry, true
  end
end
