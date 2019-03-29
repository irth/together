require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test 'show, create and join should redirect to log in when not logged in' do
    get playlist_url(1)
    assert_redirected_to auth_path(:spotify)

    post new_playlist_url
    assert_redirected_to auth_path(:spotify)

    post join_playlist_url(1)
    assert_redirected_to auth_path(:spotify)
  end

  test 'join_request and join should redirect to root if the key is wrong' do
    playlist = playlists(:empty)
    get join_playlist_url(playlist, key: "#{playlist.key}-incorrect")
    assert_redirected_to root_url

    log_in_as users(:bike)
    post join_playlist_url(playlist, key: "#{playlist.key}-incorrect")
    assert_redirected_to root_url
  end

  test 'join_request and join should redirect to root if the playlist is full' do
    playlist = playlists(:full)
    get join_playlist_url(playlist, key: playlist.key)
    assert_redirected_to root_url

    log_in_as users(:bob)
    post join_playlist_url(playlist, key: playlist.key)
    assert_redirected_to root_url
  end

  test 'join_request should redirect to playlist if the user is already in the playlist' do
    playlist = playlists(:full)
    log_in_as playlist.user1
    get join_playlist_url(playlist, key: playlist.key)
    assert_redirected_to playlist
  end

  test 'join should add the user to the playlist' do
    u = users(:bob)
    playlist = playlists(:empty)
    log_in_as u
    post join_playlist_url(playlist, key: playlist.key)
    assert playlist.reload.user2 == u
    assert_redirected_to playlist
  end
end
