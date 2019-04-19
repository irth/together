ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  def log_in_as(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:spotify] = generate_auth_hash(user.display_name)
    get '/auth/spotify'
    follow_redirect!
  end

  private

  def generate_auth_hash(name)
    OmniAuth::AuthHash.new(
      provider: "id_#{name}",
      uid: "id_#{name}",
      info: OmniAuth::AuthHash::InfoHash.new(
        display_name: name,
        email: "#{name}@example.com",
        followers: OmniAuth::AuthHash.new(
          href: '',
          total: 5
        ),
        images: [],
        product: '',
        external_urls: OmniAuth::AuthHash.new(
          spotify: "https://open.spotify.com/user/id_#{name}"
        ),
        href: "https://api.spotify.com/v1/users/id_#{name}",
        id: "id_#{name}",
        type: 'user',
        uri: "spotify:user:id_#{name}"
      ),
      credentials: OmniAuth::AuthHash.new(
        token: "token_#{name}",
        refresh_token: "refresh_token_#{name}",
        expires_at: 3.days.from_now,
        expires: true
      ),
      extra: OmniAuth::AuthHash.new
    )
  end
end
