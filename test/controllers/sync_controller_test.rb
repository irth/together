require 'test_helper'

class SyncControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'should redirect to log in when not logged in' do
    post start_sync_url
    assert_redirected_to auth_path(:spotify)
  end

  test 'should start the SyncMusicLibraryJob when called' do
    log_in_as users(:mike)
    assert_enqueued_jobs 1, only: SyncMusicLibraryJob do
      post start_sync_url(playlist: playlists(:full))
    end
  end
end
