class PagesController < ApplicationController
  before_action :require_authentication
  def index
    scoped_games = current_user.bingo_games

    @incomplete_bingo_games = scoped_games.left_joins(:squares)
      .group("bingo_games.id")
      .having(
        "COUNT(DISTINCT CASE WHEN squares.content IS NOT NULL AND squares.content != '' THEN squares.id ELSE NULL END) < 24"
      )
      .distinct
      .includes(:squares)
    @bingo_games = scoped_games.joins(:squares)
      .where.not(squares: { content: [ nil, "" ] })
      .group("bingo_games.id")
      .having("COUNT(DISTINCT squares.id) = 24")
      .distinct
      .includes(:squares)
  end
end
