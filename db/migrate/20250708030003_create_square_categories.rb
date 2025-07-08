class CreateSquareCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :square_categories do |t|
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
