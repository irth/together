class PlaylistStatusChannel < ApplicationCable::Channel
  def subscribed
    playlist = Playlist.find_by(id: params[:playlist_id])
    if playlist&.user?(current_user)
      stream_for playlist
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
