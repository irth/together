require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test 'show, create, join, save_form and save should redirect to log in when not logged in' do
    playlist = playlists(:empty)

    get playlist_url(1)
    assert_redirected_to auth_path(:spotify)

    post new_playlist_url
    assert_redirected_to auth_path(:spotify)

    post join_playlist_url(playlist, key: playlist.key)
    assert_redirected_to auth_path(:spotify)

    get save_playlist_url(playlist)
    assert_redirected_to auth_path(:spotify)

    post save_playlist_url(playlist)
    assert_redirected_to auth_path(:spotify)
  end

  test 'show, save_form and save should redirect to root_url when the user is not in the playlist' do
    bob = users(:bob)

    playlist = playlists(:full)
    assert_not playlist.user? bob

    log_in_as(bob)

    get playlist_url(playlist)
    assert_redirected_to root_url

    get save_playlist_url(playlist)
    assert_redirected_to root_url

    post save_playlist_url(playlist)
    assert_redirected_to root_url
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

  test 'save_form and save should redirect to the playlist if the playlist is not ready' do
    playlist = playlists(:empty)
    assert_not playlist.ready?

    log_in_as playlist.user1

    get save_playlist_url(playlist)
    assert_redirected_to playlist

    post save_playlist_url(playlist)
    assert_redirected_to playlist
  end

  test 'save_form should flash an error when provided with an invalid name' do
    playlist = playlists(:full)
    log_in_as playlist.user1

    # empty name
    post save_playlist_url(playlist), params: { name: '' }
    assert_not flash.empty?
    assert_template :save_form

    # name too long
    post save_playlist_url(playlist), params: { name: 'a' * 101 }
    assert_not flash.empty?
    assert_template :save_form
  end
end
