class PlaylistsController < ApplicationController
  before_action :logged_in_user, only: %i[show create]
  before_action :logged_in_user_force_redirect, only: %i[join]
  before_action :find_playlist, only: %i[show join_request join]
  before_action :correct_key, only: %i[join join_request]

  def show
    redirect_to root_url and return unless @playlist.user?(current_user)
  end

  def create
    playlist = Playlist.new
    playlist.user1 = current_user
    playlist.save

    redirect_to playlist
  end

  def join_request; end

  def join
    @playlist.user2 = current_user
    @playlist.save
    redirect_to @playlist
  end

  def find_playlist
    @playlist = Playlist.find(params[:id])
  end

  def correct_key
    redirect_to root_url and return unless params[:key] == @playlist.key
    redirect_to root_url and return if @playlist.full?
    redirect_to @playlist if @playlist.user?(current_user)
  end
end
