class User < ApplicationRecord
  serialize :spotify_user, Hash

  has_many :users_tracks
  has_many :tracks, through: :users_tracks

  def playlists
    Playlist.where("user1_id = ? OR user2_id = ?", self.id, self.id)
  end

  def self.find_or_create_by_spotify(spotify_user)
    u = User.find_or_initialize_by(spotify_id: spotify_user.id)

    success = u.update(display_name: spotify_user.display_name,
                       email: spotify_user.email,
                       spotify_id: spotify_user.id,
                       spotify_user: spotify_user.to_hash)

    return nil unless success

    u
  end
end
