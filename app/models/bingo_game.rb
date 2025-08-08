class BingoGame < ApplicationRecord
  belongs_to :user
  has_many :squares, dependent: :destroy

  attribute :has_bingo, :boolean, default: false

  validates :has_bingo, inclusion: { in: [ true, false ] }

  def get_completed_squares
    squares.where(completed: true).pluck(:ordering)
  end

  def percentage_completed
    total_squares = 25
    completed_count = squares.where(completed: true).count

    free_space_square = squares.find_by(ordering: 12)
    if free_space_square.nil? || !free_space_square.completed?
      completed_count += 1
    end

    total_squares.zero? ? 0 : (completed_count.to_f / total_squares.to_f * 100).round(0)
  end

  def check_is_ready
    squares_to_check = squares.where.not(ordering: 12)
    squares_to_check.size == 24 && squares_to_check.all? { |square| square.content.present? }
  end

  def check_for_bingo!
    return false if self.has_bingo?

    all_squares = squares.to_a

    completed_squares_map = {}
    ordering_map = {}
    all_squares.each do |square|
      if square.completed?
        row = square.ordering / 5
        col = square.ordering % 5
        completed_squares_map[[ row, col ]] = true
        ordering_map[[ row, col ]] = square.ordering
      end
    end

    completed_squares_map[[ 2, 2 ]] = true
    ordering_map[[ 2, 2 ]] ||= squares.find_by(ordering: 12)&.ordering || 12

    board_state = ->(r, c) { completed_squares_map.key?([ r, c ]) }

    bingos = []

    # Check rows
    (0..4).each do |r|
      if (0..4).all? { |c| board_state.call(r, c) }
        bingos << (0..4).map { |c| ordering_map[[ r, c ]] }
      end
    end

    # Check columns
    (0..4).each do |c|
      if (0..4).all? { |r| board_state.call(r, c) }
        bingos << (0..4).map { |r| ordering_map[[ r, c ]] }
      end
    end

    # Check main diagonal
    if (0..4).all? { |i| board_state.call(i, i) }
      bingos << (0..4).map { |i| ordering_map[[ i, i ]] }
    end

    # Check anti-diagonal
    if (0..4).all? { |i| board_state.call(i, 4 - i) }
      bingos << (0..4).map { |i| ordering_map[[ i, 4 - i ]] }
    end

    if bingos.any?
      mark_bingo_and_return_true!
      return bingos.flatten.uniq
    end

    nil
  end

  private

  def mark_bingo_and_return_true!
    update!(has_bingo: true)
    true
  end
end
