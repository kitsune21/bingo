class AddQuantityAndQuantityCompletedToSquares < ActiveRecord::Migration[8.0]
  def change
    add_column :squares, :quantity, :integer
    add_column :squares, :quantity_completed, :integer
  end
end
