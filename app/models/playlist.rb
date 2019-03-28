class Playlist < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User', optional: true

  has_secure_token :key

  def user?(user)
    !user.nil? && (user1 == user || user2 == user)
  end

  def other_user(user)
    user1 == user ? user2 : user1
  end

  def full?
    !user2.nil?
  end
end
