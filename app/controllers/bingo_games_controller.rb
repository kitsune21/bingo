class BingoGamesController < ApplicationController
  before_action :require_authentication
  before_action :set_bingo_game, only: %i[ update destroy ]

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

  def destroy
    if @bingo_game.destroy()
      redirect_to root_path, notice: "Bingo game has been deleted"
    end
  end
  def update
    respond_to do |format|
      if @bingo_game.update(bingo_game_params)
        format.html { redirect_to @bingo_game, notice: "Bingo game was successfully updated." }
        format.json { render :show, status: :ok, location: @bingo_game }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bingo_game.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@bingo_game, partial: "bingo_games/form", locals: { bingo_game: @bingo_game }) } # Example for errors
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", message: "Bingo game not found" }, status: :not_found
  end
  private

  def bingo_game_params
    params.require(:bingo_game).permit(:name)
  end

  def set_bingo_game
    @bingo_game = BingoGame.find(params[:id])
  end

  def require_authentication
    redirect_to login_path unless authenticated?
  end
end
