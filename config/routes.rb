Rails.application.routes.draw do
  resources :test, only: [:index]

  namespace :v1 do
    namespace :account do
      post 'login', to: 'sessions#create'
      post 'logout', to: 'sessions#destroy'
      post 'register', to: 'accounts#create'

      resource :v_codes, only: [:create]
      resource :verify_vcode, only: [:create]
    end

    resources :users, module: :users, only: [] do
      member do
        get :profile
      end
    end
  end

end
