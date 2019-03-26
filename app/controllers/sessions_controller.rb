class SessionsController < ApplicationController
  def spotify
    u = RSpotify::User.new(request.env['omniauth.auth'])
    @user = User.find_or_create_by_spotify u

    if @user
      log_in @user
      redirect_to homepage_url
    else
    	raise "find_or_create_by_spotify failed"
    end
  end
end
