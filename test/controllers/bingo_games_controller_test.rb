require "test_helper"

class BingoGamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    log_in_as(@user)
  end

  test "should get new" do
    get new_bingo_game_url
    assert_response :success
  end
end
