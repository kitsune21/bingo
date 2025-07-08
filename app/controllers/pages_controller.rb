class PagesController < ApplicationController
  def index
    @bingo_games = current_user&.bingo_games || []
  end
end
