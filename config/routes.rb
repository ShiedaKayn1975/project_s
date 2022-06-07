Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'signup' , to: 'accounts#create'
      post 'signin' , to: 'sessions#create'
      post 'verify_activation_token', to: 'sessions#verify_activation_token'
      post 'change_password', to: 'sessions#change_password'
      get  'profile', to: 'me#profile'
      get  'get_trading_history', to: 'action_logs#get_trading_history'
      get  'hello', to: 'hello#hello'

      jsonapi_resources :users do
        resources :actions, only: [:create, :index]
      end

      jsonapi_resources :products do
        resources :actions, only: [:create, :index]
      end

      jsonapi_resources :transactions

      jsonapi_resources :variants do 
        collection do 
          post :import_variants
        end
      end
    end
  end
end
