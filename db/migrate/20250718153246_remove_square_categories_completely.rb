class RemoveSquareCategoriesCompletely < ActiveRecord::Migration[8.0]
  def change
    remove_reference :squares, :square_category, null: false, foreign_key: true
    drop_table :square_categories
  end
end
