require "test_helper"

class SquaresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get squares_create_url
    assert_response :success
  end

  test "should get edit" do
    get squares_edit_url
    assert_response :success
  end
end
