class SyncController < ApplicationController
  def start
  	render plain: "syncing for #{current_user.display_name}"
  end
end
