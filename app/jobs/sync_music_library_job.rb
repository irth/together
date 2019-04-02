require 'rspotify'

class SyncMusicLibraryJob < ApplicationJob
  queue_as :default

  def send_status(user, playlist, saved, done = false)
    return unless playlist

    PlaylistStatusChannel.broadcast_to(
      playlist,
      type: 'sync_status',
      user: user.id,
      html: ApplicationController.renderer.render(
        partial: 'playlists/status',
        locals: {
          syncing: true,
          user: user,
          saved_count: saved,
          done: done
        }
      )
    )
  end

  def perform(user, playlist)
    # TODO: report progress via Active Cable
    u = RSpotify::User.new user.spotify_user

    offset = 0
    limit = 50

    user.users_tracks.destroy_all

    saved = 0
    send_status(user, playlist, saved)
    loop do
      tracks = u.saved_tracks(limit: limit, offset: offset)
      offset += limit

      tracks.each do |track|
        t = Track.create_with(artists: track.artists.map(&:name),
                              album: track.album.name,
                              title: track.name)
                 .find_or_create_by(spotify_id: track.id)

        relation = UsersTracks.new
        relation.track = t
        relation.user = user
        relation.save
        saved += 1
        send_status(user, playlist, saved) if saved % 5 == 0
      end
      send_status(user, playlist, saved)

      break if tracks.size < limit
    end
    send_status(user, playlist, saved, done = true)

    user.last_synced_at = DateTime.now
    user.save
  end
end
