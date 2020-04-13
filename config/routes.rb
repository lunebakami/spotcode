Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root 'home#index'

  concern :favoritable do |option|
    shallow do
      post '/favorite', { to: "favorites#create", on: :member }.merge(options)
      delete '/favorite', { to: "favorites#destroy", on: :member }.merge(options)
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :dashboard, only: :index
      resources :categories, only: [:index, :show]
      resources :search, only: :index
      resources :albums, only: :show do
        resources :recently_heards, only: :create
        concern :favoritable, favoritable_type: "Albums"
      end
      resources :favorites, only: :index

      resources :songs, only: [] do
        concern :favoritable, favoritable_type: "Song"
      end

      resources :artists, only: [] do
        concern :favoritable, favoritable_type: "Artists"
      end
    end
  end
end
