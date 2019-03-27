class AddKeyToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :key, :string
    add_index :playlists, :key, unique: true
  end
end
