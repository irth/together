class User < ApplicationRecord
  def self.find_or_create_spotify spotify_user
    u = User.create_with(display_name: spotify_user.display_name,
                         email: spotify_user.email,
                         spotify_id: spotify_user.id)
    .find_or_create_by(spotify_id: spotify_user.id)

    return false unless u

    u.update(access_token: spotify_user.credentials.token,
             refresh_token: spotify_user.credentials.refresh_token,
             expires_at: Time.at(spotify_user.credentials.expires_at).to_datetime)
  end
end
