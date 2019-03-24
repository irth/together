class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :email
      t.string :spotify_id
      t.string :access_token
      t.datetime :expires_at
      t.string :refresh_token

      t.timestamps
    end
  end
end
