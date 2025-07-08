class CreateSquares < ActiveRecord::Migration[8.0]
  def change
    create_table :squares do |t|
      t.string :content
      t.references :bingo, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.boolean :completed
      t.datetime :completed_on

      t.timestamps
    end
  end
end
