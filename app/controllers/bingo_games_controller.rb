class BingoGamesController < ApplicationController
  before_action :require_authentication

  def index
    @bingo_games = current_user.bingo_games
  end

  def new
    @bingo_game = BingoGame.new
  end

  def create
    @bingo_game = current_user.bingo_games.build(bingo_game_params)
    if @bingo_game.save
      redirect_to root_path, notice: "Bingo game has been created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bingo_game_params
    params.require(:bingo_game).permit(:name)
  end

  def require_authentication
    redirect_to login_path unless authenticated?
  end
end
