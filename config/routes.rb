Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'revenue#index'
        get '/most_items', to: 'items#index'
      end

      namespace :items do
        get '/find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      resources :merchants, only: [:index, :show, :create, :update, :destroy] do
        resources :items, only: [:index]
      end

      resources :items, only: [:index, :show, :create, :update, :destroy]

      get '/items/:item_id/merchant', to: 'merchants#show'

      get '/revenue', to: 'revenue#index'
      get '/merchants/:id/revenue', to: 'revenue#show'
    end
  end
end
