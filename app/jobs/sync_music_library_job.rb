require 'rspotify'

class SyncMusicLibraryJob < ApplicationJob
  queue_as :default

  def perform(user)
    # TODO: report progress via Active Cable
    u = RSpotify::User.new user.spotify_user

    offset = 0
    limit = 50

    user.users_tracks.destroy_all

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
      end

      break if tracks.size < limit
    end

    user.last_synced_at = DateTime.now
    user.save
  end
end
