Rails.application.routes.draw do
  resources :test, only: [:index]

  namespace :v1 do
    resources :app_versions, only:[:index]
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
        resources :integral, only: [] do
          post :tasks,     on: :collection
          get  :details,   on: :collection
          post :award,     on: :collection
        end
        resources :coupons, only: [:index, :show]
        resources :novice_task, only: [:index]
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
      resources :jmessage, only: [:index, :create, :destroy]
      resources :login_count, only: [:create]
      resources :share_count, only: [:create]
      resources :coupons, only: [] do
        get :search, on: :collection
      end
    end

    # 资讯相关
    resources :infos, only: [:show] do
      get :coupons, on: :member
      post :receive_coupon, on: :member
    end
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
      resources :notify, only: [] do
        post :shop_order, on: :collection
        post :hotel_order, on: :collection
      end
    end

    namespace :ali do
      resources :notify, only: [] do
        post :shop_order, on: :collection
        post :hotel_order, on: :collection
      end
    end

    # 说说或长帖
    resources :topics, only: [:index, :show, :create, :destroy] do
      post :image, on: :collection
      get :essence, on: :collection
    end

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

    # 用户反馈
    resources :feedbacks, only: [:create]

    # 获取位置服务
    resources :locations, only: [:index]

    # 消息通知
    resources :topic_notifications, only: [:index, :destroy] do
      get 'unread_count', on: :collection
    end

    # 酒店模块
    resources :hotels, only: [:show, :index] do
      get 'rooms', on: :member
      get 'regions', on: :collection
    end
    resources :hotel_orders, only:[:show, :index, :create, :destroy] do
      post 'new', on: :collection
      post 'wx_pay', on: :member
      get  'wx_paid_result', on: :member
      post 'alipay', on: :member
      post 'cancel', on: :member
      post 'refund', on: :member
    end

    # 积分商城
    namespace :integral_malls do
      resources :coupons, only: [:index, :show] do
        post 'exchange', on: :member
      end
    end

    # 邀请奖励模块
    resources :my_invites, only: [:index] do
      get 'indirect', on: :collection
      get 'award_details', on: :collection
      get 'display_check', on: :collection
      get 'count', on: :collection
    end

    # 钱包
    resource :wallet, only: [] do
      get 'account', on: :collection
      get 'account_details', on: :collection
      post 'withdrawal', on: :collection
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
        post 'new', on: :collection, as: :new
        post :cancel, on: :member
        post :confirm, on: :member
        post :wx_pay, on: :member
        post :alipay, on: :member
        post :customer_return, on: :member
        get :wx_paid_result, on: :member
        get :express_tracking, on: :member
      end
    end

    resources :exchange_rates, only: [:index]
    resources :exchange_traders, only: [:index]
    resources :hotlines, only: [:index]
    resources :contacts, only: [:index]

    # Merchant 商户模块
    namespace :merchant do
      resources :sale_room_requests
      resource  :v_codes, only: [:create]
      resource  :verify_vcode, only: [:create]
      resources :account, only: [] do
        post :register, on: :collection
        post :login, on: :collection
        put :update, on: :collection
      end
    end
  end
end
