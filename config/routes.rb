Rails.application.routes.draw do
  namespace :v1 do
    namespace :account do
      post 'login', to: 'sessions#create'
      post 'logout', to: 'sessions#destroy'
      post 'register', to: 'accounts#create'
    end

    resources :users, module: :users, only: [] do
      member do
        get :profile
      end
    end
  end

end
