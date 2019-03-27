class AddIndicesToUsersTracks < ActiveRecord::Migration[5.2]
  def change
  	add_index :users_tracks, :track_id
  	add_index :users_tracks, :user_id
  end
end
