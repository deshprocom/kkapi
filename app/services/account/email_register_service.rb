module Services
  module Account
    class EmailRegisterService
      include Serviceable

      attr_accessor :email, :password

      def initialize(params)
        self.email = params[:email]&.downcase
        self.password = params[:password]
      end

      def call
        # 检查邮箱格式是否正确
        raise_error 'email_format_error' if email.blank? || !UserValidator.email_valid?(email)

        # 检查邮箱是否存在
        raise_error 'email_already_userd' if UserValidator.email_exists?(email)

        # 检查密码是否合法
        raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(password)

        # 可以注册, 创建一个用户
        user = User.create_by_email(email, password)

        # 新用户送优惠券
        Services::Account::AwardCouponService.call(user)

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        # 记录一次账户修改
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
