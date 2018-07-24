module Services
  module Weixin
    class AuthService
      include Serviceable
      attr_accessor :user_params, :wx_authorize

      def initialize(user_params, wx_authorize)
        self.user_params = user_params
        self.wx_authorize = wx_authorize
      end

      def call
        # 拿到用户传递过来的code
        code = user_params[:code]

        # 新增 获取用户传过来的refresh_token
        # 如果用户传了refresh_token 那么就直接通过refresh_token去拿token
        refresh_token = user_params[:refresh_token]
        token_result = refresh_token.blank? ? access_token(code) : refresh_token(refresh_token)

        # 获取access_token和open_id
        # token_result = access_token(code) # 废弃
        raise_error 'weixin_auth_error' unless token_result.code.zero?
        token_result = token_result.result

        # 拿到用户的信息
        wx_user = wx_user_info(token_result[:openid], token_result[:access_token])
        raise_error 'weixin_auth_error' unless wx_user.code.zero?
        wx_user = wx_user.result

        wx_user.merge! token_result
        check_wx_user(wx_user)
      end

      private

      def access_token(code)
        token_result = wx_authorize.get_oauth_access_token(code)
        Rails.logger.info "wx_authorize_token_result: #{token_result.as_json}"
        token_result
      end

      def refresh_token(token)
        token_result = wx_authorize.refresh_oauth2_token(token)
        Rails.logger.info "wx_authorize_refresh_token_result: #{token_result.as_json}"
        token_result
      end

      def wx_user_info(open_id, access_token)
        user_info = wx_authorize.get_oauth_userinfo(open_id, access_token)
        Rails.logger.info "wx_authorize_user_info: #{user_info.as_json}"
        user_info
      end

      # unionid 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
      def check_wx_user(info)
        wx_user = WeixinUser.find_by(union_id: info[:unionid])
        wx_user.nil? ? record_and_return_data(info) : update_and_return_data(wx_user, info)
      end

      def record_and_return_data(params)
        # 数据库中没有该用户的记录
        WeixinUser.create(wx_user_params(params))
        # 返回access_token, open_id等信息给前端
        return_access_token(params[:access_token])
      end

      def update_and_return_data(wx_user, params)
        wx_user.update(wx_user_params(params))
        # 判断该记录是否有绑定过用户，如果有记录但是没有绑定用户，那么返回access_token给前端
        user = wx_user.user
        return return_access_token(wx_user[:access_token]) if user.nil?

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        ApiResult.success_with_data(login_result(user, access_token))
      end

      def return_access_token(access_token)
        ApiResult.success_with_data(type: 'register', data: { access_token: access_token })
      end

      def wx_user_params(params)
        { open_id: params[:openid],
          nick_name: params[:nickname],
          sex: params[:sex],
          province: params[:province],
          city: params[:city],
          country: params[:country],
          head_img: params[:headimgurl],
          privilege: JSON(params[:privilege]),
          union_id: params[:unionid],
          access_token: params[:access_token],
          expires_in: params[:expires_in],
          refresh_token: params[:refresh_token] }
      end

      def login_result(user, access_token)
        {
          type: 'login',
          data: { user: user,
                  access_token: access_token }
        }
      end
    end
  end
end
