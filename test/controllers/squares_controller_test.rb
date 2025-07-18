# test/controllers/squares_controller_test.rb
require "test_helper"

class SquaresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a user fixture
    @bingo_game = bingo_games(:one) # Assuming you have a bingo_game fixture
    @square = squares(:one) # If you have square fixtures

    # Sign in the user (adjust this based on your authentication method)
    post login_path, params: { email_address: @user.email_address, password: "password" }
    # OR if you have a different sign-in method, use that
  end

  test "should create square" do
    assert_difference("Square.count") do
      post bingo_game_squares_path(@bingo_game),
           params: { square: { content: "Test content", ordering: 1 } },
           as: :json
    end

    assert_response :created
    assert_equal "success", JSON.parse(response.body)["status"]
  end

  test "should update square" do
    patch bingo_game_square_path(@bingo_game, @square),
          params: { square: { content: "Updated content" } },
          as: :json

    assert_response :success
    assert_equal "success", JSON.parse(response.body)["status"]
  end

  # Remove the edit test since you don't have an edit action
  # Or if you need an edit action, add it to your controller
end
