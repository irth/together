class AddLastSyncedAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_synced_at, :datetime
  end
end
