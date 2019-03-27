class SyncController < ApplicationController
  def start
  	# TODO: require an user
  	SyncMusicLibraryJob.perform_later current_user
  	render plain: "syncing for #{current_user.display_name}"
  end
end
