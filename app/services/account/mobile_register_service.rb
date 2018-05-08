module Services
  module Account
    class MobileRegisterService
      include Serviceable
      attr_accessor :mobile, :vcode, :password

      def initialize(params)
        self.mobile = params[:mobile]
        self.vcode = params[:vcode]
        self.password = params[:password]
      end

      def call
        # 检查手机格式是否正确
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(mobile)

        # 检查验证码是否正确
        raise_error 'vcode_not_match' unless VCode.check_vcode('register', mobile, vcode)

        # 检查手机号是否存在
        raise_error 'mobile_already_used' if UserValidator.mobile_exists?(mobile)

        # 检查密码是否合法
        raise_error 'password_format_wrong' if password.present? && !UserValidator.pwd_valid?(password)

        # 可以注册, 创建一个用户
        user = User.create_by_mobile(mobile, password)

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
