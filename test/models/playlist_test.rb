require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'ready? returns false when not full' do
    p = playlists(:empty)
    assert_not p.ready?
  end

  test 'ready? returns false when full but the users have not synced their libraries yet' do
    p = playlists(:full)
    p.user1.update(last_synced_at: nil)
    assert_not p.ready?

    p.user1.update(last_synced_at: Time.now)
    p.user2.update(last_synced_at: nil)
    assert_not p.ready?
  end

  test 'ready? returns true when both users have synced their libraries' do
    p = playlists(:full)
    p.user2.update(last_synced_at: Time.now)
    p.user2.update(last_synced_at: Time.now)
    assert p.ready?
  end

  test 'tracks returns false for a playlist that is not ready' do
    p = playlists(:empty)
    assert_not p.ready?
    assert_not p.tracks
  end
end
