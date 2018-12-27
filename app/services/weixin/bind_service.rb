module Services
  module Weixin
    class BindService
      include Serviceable

      def initialize(wx_user, user_params)
        @wx_user = wx_user
        @user_params = user_params
      end

      def call
        # 验证手机验证码是否正确
        account = @user_params[:account]
        unless check_code('bind_wx_account', "+#{@user_params[:ext]}#{account}", @user_params[:code])
          raise_error 'vcode_not_match'
        end

        # 判断该微信是否有绑定过其它用户
        raise_error 'weixin_already_bind' if @wx_user.user.present?

        # 查看该手机号是否注册过
        user = User.by_mobile(account)

        user.nil? ? create_user : bind_already_exist_user(user)
      end

      private

      def check_code(type, account, code)
        return true if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        VCode.check_vcode(type, account, code)
      end

      def create_user
        password = @user_params[:password]
        raise_error 'password_format_wrong' if password.present? && !UserValidator.pwd_valid?(password)

        # 可以注册, 创建一个用户
        user = User.create_by_mobile(@user_params[:account], password, @user_params[:ext])
        gender = @wx_user.sex.to_i.eql?(1) ? 1 : 0
        user.update(nick_name: @wx_user.nick_name, wx_avatar: @wx_user.head_img, gender: gender)

        # 新用户送优惠券
        Services::Account::AwardCouponService.call(user)
        # 微信注册的用户也要记录等级
        UserRelationCreator.call(user, nil)

        # 绑定用户
        bind_wx_user(user)
      end

      def bind_already_exist_user(user)
        # 查看该手机号用户是否绑定过其它微信
        raise_error 'account_already_bind' if user.weixin_user.present?

        # 更新用户头像到用户表里面
        user.update(wx_avatar: @wx_user.head_img)

        bind_wx_user(user)
      end

      def bind_wx_user(user)
        # 绑定该微信到该用户
        @wx_user.update(user_id: user.id)

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        # 记录一次账户修改
        Account::LoginResultHelper.call(user, access_token)
      end
    end
  end
end
