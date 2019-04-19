require 'rspotify'

include ActionView::Helpers::DateHelper

class SyncMusicLibraryJob < ApplicationJob
  queue_as :default

  def perform(user, credentials, playlist)
    u = RSpotify::User.new({ "credentials" => credentials })
    offset = 0
    limit = 50

    user.users_tracks.destroy_all

    saved = 0

    PlaylistStatusChannel.broadcast_to(
      playlist,
      event: 'sync_start',
      user: user.id.to_s
    )

    loop do
      tracks = u.saved_tracks(limit: limit, offset: offset)
      offset += limit

      tracks.each do |track|
        t = Track.create_with(artists: track.artists.map(&:name),
                              album: track.album.name,
                              title: track.name,
                              url: track.external_urls['spotify'])
                 .find_or_create_by(spotify_id: track.id)

        relation = UsersTracks.new
        relation.track = t
        relation.user = user
        relation.save
        saved += 1

        # send a status update every 7 songs
        next unless saved % 7

        PlaylistStatusChannel.broadcast_to(
          playlist,
          event: 'sync_update',
          user: user.id.to_s,
          songs: saved
        )
      end

      PlaylistStatusChannel.broadcast_to(
        playlist,
        event: 'sync_update',
        user: user.id.to_s,
        songs: saved
      )

      break if tracks.size < limit
    end

    user.last_synced_at = DateTime.now
    user.save

    PlaylistStatusChannel.broadcast_to(
      playlist,
      event: 'sync_done',
      user: user.id.to_s,
      lastSyncedAt: user.last_synced_at,
      tracks: playlist.tracks
    )
  end
end
