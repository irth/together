class AddRSpotifyHashToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :spotify_user, :string
  	remove_column :users, :access_token
  	remove_column :users, :refresh_token
  	remove_column :users, :expires_at
  end
end
