class CreateBingoGames < ActiveRecord::Migration[8.0]
  def change
    create_table :bingo_games do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
