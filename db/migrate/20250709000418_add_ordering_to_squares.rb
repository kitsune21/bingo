class AddOrderingToSquares < ActiveRecord::Migration[8.0]
  def change
    add_column :squares, :ordering, :integer
  end
end
