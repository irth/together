class PlaylistsController < ApplicationController
  before_action :logged_in_user, only: %i[show create save_form save]
  before_action :logged_in_user_force_redirect, only: %i[join]

  before_action :find_playlist, only: %i[show join_request join save_form save]

  def show
    require_correct_user or return
    @other_user = @playlist.other_user(current_user)
  end

  def create
    playlist = Playlist.new
    playlist.user1 = current_user
    playlist.save

    redirect_to playlist
  end

  def join_request
    require_correct_key or return
  end

  def join
    require_correct_key or return

    @playlist.user2 = current_user
    @playlist.save

    PlaylistStatusChannel.broadcast_to(
      @playlist,
      event: 'join',
      user: current_user.id.to_s,
      displayName: current_user.display_name,
      lastSyncedAt: current_user.last_synced_at,
      tracks: @playlist.tracks
    )

    redirect_to @playlist
  end

  def save_form
    require_correct_user or return
    require_ready or return
  end

  def save
    require_correct_user or return
    require_ready or return

    unless params[:name].length.between?(1, 100)
      flash.now[:error] = if params[:name].length > 100
                            'The playlist name must be shorter than 100 characters.'
                          else
                            'The playlist name cannot be empty.'
                          end
      render 'save_form' and return
    end
    s = RSpotify::User.new('id' => current_user.spotify_id, 'credentials' => spotify_credentials)

    # there's probably a bug in rspotify's code making it impossible to create
    # a private playlist
    playlist = s.create_playlist!(params[:name])

    tracks = @playlist.tracks.map { |t| "spotify:track:#{t.spotify_id}" }
    tracks.each_slice 50 do |s|
      playlist.add_tracks! s
    end

    flash[:success] = 'Saved the playlist to your Spotify account.'
    redirect_to @playlist
  end

  private

  def find_playlist
    @playlist = Playlist.find(params[:id])
  end

  def require_correct_user
    redirect_to(root_url) and return false unless @playlist.user?(current_user)
    true
  end

  def require_correct_key
    redirect_to root_url and return false unless params[:key] == @playlist.key
    redirect_to @playlist and return false if @playlist.user?(current_user)
    redirect_to root_url and return false if @playlist.full?
    true
  end

  def require_ready
    redirect_to @playlist and return false unless @playlist.ready?
    true
  end
end
