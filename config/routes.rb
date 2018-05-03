Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/players/login', to: 'players#login' #could also add 'update' to above array
  namespace :api do
    namespace :v1 do
      resources :player_slots
      resources :matches
      resources :players
    end
  end
end
