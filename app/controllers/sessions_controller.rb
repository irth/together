class SessionsController < ApplicationController
  def spotify
    auth_hash = request.env['omniauth.auth']
    @user = User.find_or_create_by_auth_hash auth_hash

    if @user
      log_in @user
      remember @user

      # store spotify credentials for the SyncMusicLibraryJob
      save_spotify_credentials auth_hash.credentials

      redirect_back_or root_url
    else
      raise 'find_or_create_by_spotify failed'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
