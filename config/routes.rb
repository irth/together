Rails.application.routes.draw do
  # static
  get '/', to: 'static_pages#home', as: 'root'

  # playlists
  post 'playlists', to: 'playlists#create', as: 'new_playlist'

  get 'playlists/:id', to: 'playlists#show', as: 'playlist'

  get 'j/:id/:key', to: 'playlists#join_request', as: 'join_playlist'
  post 'j/:id/:key', to: 'playlists#join'

  get 'playlists/:id/save', to: 'playlists#save_form', as: 'save_playlist'
  post 'playlists/:id/save', to: 'playlists#save'

  # sync
  post 'sync/start', as: 'start_sync'

  # auth
  get '/auth/spotify/callback', to: 'sessions#spotify'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
