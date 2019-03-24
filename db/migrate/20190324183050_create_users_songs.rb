class CreateUsersSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :users_songs do |t|
      t.integer :user_id
      t.integer :song_id

      t.timestamps
    end
  end
end
