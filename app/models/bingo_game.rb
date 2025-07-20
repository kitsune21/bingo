class BingoGame < ApplicationRecord
  belongs_to :user
  has_many :squares, dependent: :destroy
  def percentage_completed
    total_squares = 25
    completed_count = squares.where(completed: true).count + 1
    total_squares.zero? ? 0 : (completed_count.to_f / total_squares.to_f * 100).round(0)
  end
end
