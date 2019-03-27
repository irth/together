class RenameUsersSongsToUsersTracks < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users_songs, :song_id, :track_id
  	rename_table :users_songs, :users_tracks
  end
end
