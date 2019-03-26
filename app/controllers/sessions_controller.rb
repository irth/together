class SessionsController < ApplicationController
	def spotify
		u = RSpotify::User.new(request.env['omniauth.auth'])
		@user = User.find_or_create_spotify u
		redirect_to homepage_url
	end
end
