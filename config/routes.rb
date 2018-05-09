Rails.application.routes.draw do
  resources :test, only: [:index]

  namespace :v1 do
    namespace :account do
      post 'login', to: 'sessions#create'
      post 'logout', to: 'sessions#destroy'
      post 'register', to: 'accounts#create'

      resource :v_codes, only: [:create]
      resource :verify_vcode, only: [:create]
      resource :reset_password, only: [:create]
      resources :users, only: [] do
        resource :profile, only: [:show, :update]
        resource :avatar, only: [:update]
        resource :change_password, only: [:create]
      end
    end

    resources :users, module: :users, only: [] do
      member do
        get :profile
      end
    end
  end

end
