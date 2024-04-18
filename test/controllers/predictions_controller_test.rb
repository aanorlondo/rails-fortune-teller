require "test_helper"

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get predictions_index_url
    assert_response :success
  end

  test "should get create" do
    get predictions_create_url
    assert_response :success
  end

  test "should get rate" do
    get predictions_rate_url
    assert_response :success
  end
end
