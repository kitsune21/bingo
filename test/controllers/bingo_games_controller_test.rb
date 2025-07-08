require "test_helper"

class BingoGamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bingo_games_index_url
    assert_response :success
  end

  test "should get new" do
    get bingo_games_new_url
    assert_response :success
  end

  test "should get create" do
    get bingo_games_create_url
    assert_response :success
  end
end
