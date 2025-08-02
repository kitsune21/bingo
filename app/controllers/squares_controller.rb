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

    updated_attributes = square_params.dup

    if updated_attributes.key?(:quantity) && @square.quantity != updated_attributes[:quantity]
      updated_attributes[:quantity_completed] = 0
    elsif updated_attributes.key?(:content) && @square.content != updated_attributes[:content]
      updated_attributes[:quantity_completed] = 0
    end

    if updated_attributes[:completed].to_s == "true"
      updated_attributes[:completed_on] = DateTime.current
    elsif updated_attributes.key?(:completed) && updated_attributes[:completed].to_s == "false"
      updated_attributes[:completed_on] = nil
    end

    if @square.update(updated_attributes)
      total_squares = 25
      completed_squares_count = @bingo_game.squares.where(completed: true).count + 1
      percentage_completed = total_squares.zero? ? 0 : (completed_squares_count.to_f / total_squares.to_f * 100).round(0)
      render json: { status: "success", message: "Square updated successfully", percentage_completed: percentage_completed, square: @square }, status: :ok
    else
      render json: { status: "error", errors: @square.errors.full_messages },
        status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", message: "Square not found" },
      status: :not_found
  end

  private

  def set_bingo_game
    @bingo_game = BingoGame.find(params[:bingo_game_id])
  rescue
    redirect_to root_path, alert: "Bingo game not found"
  end

  def square_params
    params.require(:square).permit(:content, :ordering, :completed, :completed_on, :quantity, :quantity_completed)
  end

  def bingo_game_params
    params.require(:bingo_game).permit(square_attributes: [ :id, :content, :ordering, :_destroy ])
  end
end
