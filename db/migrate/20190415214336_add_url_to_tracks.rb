class AddUrlToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :url, :string
  end
end
