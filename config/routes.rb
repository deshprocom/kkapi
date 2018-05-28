Rails.application.routes.draw do
  resources :test, only: [:index]

  namespace :v1 do
    namespace :account do
      post 'login', to: 'sessions#create'
      post 'logout', to: 'sessions#destroy'
      post 'register', to: 'accounts#create'
      get 'verify', to: 'accounts#verify'

      resource :v_codes, only: [:create]
      resource :verify_vcode, only: [:create]
      resource :reset_password, only: [:create]
      resources :users, only: [] do
        resource :profile, only: [:show, :update]
        resource :avatar, only: [:update]
        resource :change_password, only: [:create]
        resources :change_account, only: [:create]
        resources :bind_account, only: [:create]
      end
      resources :address, only: [:index, :create, :update, :destroy] do
        post :default, on: :member
      end
      resources :certification, only: [:index, :create, :update, :destroy] do
        post :default, on: :member
      end
    end

    resources :users, module: :users, only: [] do
      member do
        get :profile
        get :topics
        get :dynamics
      end
      resources :followers, only: [:index, :destroy]
      resources :following, only: [:index, :create, :destroy] do
        get :uids, on: :collection
      end
      resources :likes, only: [:index, :create] do
        post :cancel, on: :collection
      end
      resources :nearbys, only: [:index, :create]
    end

    # 酒店相关
    resources :hotels, only: [:show, :index]

    # 资讯相关
    resources :infos, only: [:show]
    resources :info_types, only: [] do
      resources :infos, only: [:show, :index] do
        get :stickied, on: :collection
      end
    end

    # 微信相关
    namespace :weixin do
      resources :auth, only: [:create]
      resources :bind, only: [:create]
      resources :js_sign, only: [:create]
    end

    # 说说或长帖
    resources :topics, only: [:index, :show, :create, :destroy] do
      post :image, on: :collection
      get :essence, on: :collection
    end

    resources :exchange_rates, only: [:index]

    # 评论和回复
    resources :comments, only: [:index, :create, :destroy] do
      get  :replies, on: :member
    end
    resources :replies, only: [:create, :destroy]

    # 举报
    resources :reports, only: [:create]

    # app 首页相关
    resources :banners, only: [:index]
    resources :recommends, only: [:index]

    # 获取位置服务
    resources :locations, only: [:index]

    # 消息通知
    resources :topic_notifications, only: [:index, :destroy] do
      get 'unread_count', on: :collection
    end

    # 商城模块
    namespace :shop do
      resources :categories, only: [:index] do
        get 'children', on: :member
      end

      resources :products do
        get 'recommended', on: :collection
      end

      resources :orders do
        post :new, on: :collection, as: :new
        post :cancel, on: :member
        post :confirm, on: :member
        post :wx_pay, on: :member
      end
    end
  end
end
