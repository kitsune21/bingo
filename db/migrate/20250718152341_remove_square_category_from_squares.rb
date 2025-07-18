class RemoveSquareCategoryFromSquares < ActiveRecord::Migration[8.0]
  def change
    remove_reference :squares, :square_category, null: false, foreign_key: true
  end
end
