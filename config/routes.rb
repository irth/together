Rails.application.routes.draw do
  get '/', to: 'static_pages#home', as: 'homepage'
  get '/auth/spotify/callback', to: 'sessions#spotify'
end
