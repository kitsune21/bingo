class DropSquareCategories < ActiveRecord::Migration[8.0]
  def change
    drop_table :square_categories do |t|
      t.string "category"
      t.integer "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_square_categories_on_user_id"
    end
  end
end