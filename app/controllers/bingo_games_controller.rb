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

  def generate_squares
    @bingo_game = BingoGame.includes(:squares).find(params[:id])

    (0..24).each do |i|
      @bingo_game.squares.find_or_initialize_by(ordering: i)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Bingo game not found"
  end

  private

  def bingo_game_params
    params.require(:bingo_game).permit(:name)
  end

  def require_authentication
    redirect_to login_path unless authenticated?
  end
end
