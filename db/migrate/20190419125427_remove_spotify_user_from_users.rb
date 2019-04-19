class RemoveSpotifyUserFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :spotify_user, :string
  end
end
