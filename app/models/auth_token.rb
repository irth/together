class AuthToken < ApplicationRecord
  belongs_to :user
  has_secure_token

  before_create do
    self.expires_at = 1.month.from_now
  end

  def refresh
    self.expires_at = 1.month.from_now
    save
  end
end
