Rails.application.routes.draw do

  get 'stats/stats'
  root 'static_pages#home'
          
  devise_for :users , controllers: {
    session: 'users/session', 
    registration: 'users/registration',
    omniauth: 'users/omniauth',
    omniauth_callbacks: "users/omniauth_callbacks",
    confirmations: 'users/confirmations'}

  get 'home'           => 'static_pages#home'
  get 'about'          => 'static_pages#about'
  get 'contact'        => 'static_pages#contact'
  
  get 'chat'           => 'chat#index'
  get 'persona/:id', to: 'film#persona', as: 'persona'
  get 'tv/:id/season/:number/episode/:episode', to: 'film#episode', as: 'episode'
  get 'tv/:id/season/:number', to: 'film#season', as: 'season'
  get 'tv/:id', to: 'film#tv', as: 'tv'
  get 'movie/:id', to: 'film#result', as: 'result'
  post'search'     => 'film#search'
  get 'search'      => 'film#search'
  get 'index'       => 'film#index'
  get 'film/persona'
  get 'film/result'
  get 'film/search'
  get 'film/index'
  get 'chat/index'
  get 'film/tv'
  get '/unban/:id', to: 'users#unban', as: 'unban'
  get '/ban/:id', to: 'users#ban', as: 'ban'
  get '/plus/:id', to: 'users#plus', as: 'plus'
  get '/minus/:id', to: 'users#minus', as: 'minus'
  delete "users/:id", to: "users#destroy"
  get 'stats' => 'stats#stats'
  get '/:id/favorites', to: "users#favorites", as: "favorites"
  get '/favorite_film/:id', to: "film#favfilm", as: "favfilm"
  get '/favorite_tv/:id', to: "film#favtv", as: "favtv"
  delete '/:id/favorite_destroy/:fav', to: "users#favdestroy", as: "favdestroy"

  mount ActionCable.server => '/cable'

  resources :films do
    resources :comments
  end

  resources :tvs do
    resources :comments
  end

  resources :comments do
    resources :comments
    member do
      put "like"    => "comments#like"
      put "dislike" => "comments#dislike"
    end
  end

  resources :tweets
  resources :users, :only =>[:show, :index, :update, :edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
