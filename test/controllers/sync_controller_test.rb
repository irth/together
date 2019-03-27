require 'test_helper'

class SyncControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get sync_start_url
    assert_response :success
  end

end
