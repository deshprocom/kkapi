module Services
  module Weixin
    class MiniprogramLogin
      include Serviceable

      def initialize(params)
        @params = params
      end

      def call
        # {"session_key"=>"MZP57fiMBj7vi6phMTkBvg==", "openid"=>"oVO6l5INNY92KDXDU9Naac-sYp3U", "unionid"=>"o9o1PwuPNP_CALKYFHdDZS2FiNGo"}
        result = Wechat.api.jscode2session(@params[:code])
        wx_user_info = Wechat.decrypt(@params[:encrypted_data], result['session_key'], @params[:iv])
        # 更新或创建weixin user
        weinxin_user = WeixinUser.find_or_initialize_by_session(wx_user_info['unionId'])
        weinxin_user.assign_attributes(wx_user_params(wx_user_info))
        weinxin_user.save_session
        login_or_register(weinxin_user)
      end

      private

      def login_or_register(weinxin_user)
        user = weinxin_user.user
        return need_register_result(weinxin_user) if user.nil?

        login_result(user)
      end

      def wx_user_params(params)
        { miniprogram_openid: params[:openId],
          nick_name: params[:nickname],
          sex: params[:gender],
          province: params[:province],
          city: params[:city],
          country: params[:country],
          head_img: params[:avatarUrl],
          union_id: params[:unionId] }
      end

      def login_result(user)
        # 刷新上次访问时间
        user.touch_visit!
        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        { status: 'login_success', access_token: access_token, user: user }
      end

      def need_register_result(weixin_user)
        # 注册的token一天有效
        access_token = UserToken.encode(weixin_user.miniprogram_openid, 1.day.to_i)
        { status: 'need_register', access_token: access_token }
      end
    end
  end
end
