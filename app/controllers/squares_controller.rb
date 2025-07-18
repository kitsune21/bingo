class SquaresController < ApplicationController
  before_action :require_authentication
  before_action :set_bingo_game
  def create
    @square = @bingo_game.squares.build(square_params)
    if @square.save
      render json: { status: "success", message: "Square created successfully", square_id: @square.id }, status: :created
    else
      render json: { status: "error", errors: @square.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @square = @bingo_game.squares.find(params[:id])
    if @square.update(square_params)
      render json: { status: "success", message: "Square updated successfully" }
    else
      render json: { status: "error", errors: @square.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", message: "Square not found" }, status: :not_found
  end
  private

  def set_bingo_game
    @bingo_game = BingoGame.find(params[:bingo_game_id])
  rescue
    redirect_to root_path, alert: "Bingo game not found"
  end

  def square_params
    params.require(:square).permit(:content, :ordering)
  end

  def bingo_game_params
    params.require(:bingo_game).permit(square_attributes: [ :id, :content, :ordering, :_destroy])
  end
end
