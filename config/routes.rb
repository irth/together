Rails.application.routes.draw do
  # static
  get '/', to: 'static_pages#home', as: 'root'

  # # playlists
  post 'playlists', to: 'playlists#create', as: 'new_playlist'
  get 'playlists/:id', to: 'playlists#show', as: 'playlist'
  get 'playlists/:id/join', to: 'playlists#join_request', as: 'join_playlist_request'
  post 'playlists/:id/join', to: 'playlists#join', as: 'join_playlist'

  # sync
  post 'sync/start', as: 'start_sync'

  # auth
  get '/auth/spotify/callback', to: 'sessions#spotify'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
