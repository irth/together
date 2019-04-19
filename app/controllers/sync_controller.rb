class SyncController < ApplicationController
  before_action :logged_in_user
  def start
    SyncMusicLibraryJob.perform_later(
      current_user,
      spotify_credentials,
      Playlist.find(params[:playlist])
    )
    render plain: "syncing for #{current_user.display_name}, via playlist #{params[:playlist]}"
  end
end
