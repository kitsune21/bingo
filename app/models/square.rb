class Square < ApplicationRecord
  belongs_to :bingo_game

  validates :ordering, presence: true, uniqueness: { scope: :bingo_game_id }, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 25 }
end
