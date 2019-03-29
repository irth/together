require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'logging in as a known spotify user should not create a new database record' do
    assert_no_difference 'User.count' do
      log_in_as(users(:bob))
    end
  end

  test 'logging in as a new spotify user should create a new database record' do
    u = users(:bob)
    u.destroy
    assert_difference 'User.count', 1 do
      log_in_as(users(:bob))
    end
  end
end
