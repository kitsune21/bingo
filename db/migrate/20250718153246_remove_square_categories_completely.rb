class RemoveSquareCategoriesCompletely < ActiveRecord::Migration[8.0]
  def change
    drop_table :square_categories
  end
end
