class User < ApplicationRecord
  serialize :spotify_user, Hash

  has_many :users_tracks
  has_many :tracks, through: :users_tracks

  def playlists
    Playlist.where("user1_id = ? OR user2_id = ?", self.id, self.id)
  end

  def self.find_or_create_by_omniauth(omniauth)
    i = omniauth.info
    u = User.find_or_initialize_by(spotify_id: i.id)

    success = u.update(display_name: i.display_name,
                       email: i.email,
                       spotify_id: i.id,
                       spotify_user: omniauth)

    return nil unless success

    u
  end
end
