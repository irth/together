class SyncController < ApplicationController
  before_action :logged_in_user
  def start
    SyncMusicLibraryJob.perform_later current_user
    render plain: "syncing for #{current_user.display_name}"
  end
end
