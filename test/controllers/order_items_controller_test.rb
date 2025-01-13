require "test_helper"

class OrderItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get order_items_destroy_url
    assert_response :success
  end
end
