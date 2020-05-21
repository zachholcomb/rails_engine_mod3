Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
        get '/:id/items', to: 'items#index'
      end
      resources :merchants, except: [:new, :edit] 

      namespace :items do
        get '/:id/merchant', to: 'merchant#show'
        get '/find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end
      resources :items, execpt: [:new, :edit]

      get '/revenue', to: 'revenue#index'
      get '/merchants/:id/revenue', to: 'revenue#show'
    end
  end
end
