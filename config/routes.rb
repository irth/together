Rails.application.routes.draw do
  get '/', to: 'static_pages#home', as: 'root'

  post 'sync/start', as: 'start_sync'

  # auth
  get '/auth/spotify/callback', to: 'sessions#spotify'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end