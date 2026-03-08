require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notifications_url
    assert_response :success
  end
end
