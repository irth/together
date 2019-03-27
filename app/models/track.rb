class Track < ApplicationRecord
  serialize :artists, Array

  has_many :users_tracks
  has_many :users, through: :users_tracks

  def self.find_common(u1, u2)
    q = <<-SQL
			SELECT * FROM tracks
				WHERE id in
					(SELECT track_id FROM users_tracks WHERE user_id=?
						INTERSECT
					 SELECT track_id FROM users_tracks WHERE user_id=?)
    SQL
    
    find_by_sql [q, u1.id, u2.id]
  end
end
