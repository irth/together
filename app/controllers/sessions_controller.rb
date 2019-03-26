class SessionsController < ApplicationController
	def spotify
		u = RSpotify::User.new(request.env['omniauth.auth'])
		@user = User.find_or_create_spotify u
		render plain: "Hello, #{@user.display_name}"
	end
end
