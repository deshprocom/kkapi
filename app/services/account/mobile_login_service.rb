module Services
  module Account
    class MobileLoginService
      include Serviceable

      attr_accessor :mobile, :password

      def initialize(mobile, password)
        self.mobile = mobile
        self.password = password
      end

      def call
        # 检查手机号格式是否正确
        raise_error 'params_missing' if mobile.blank? || password.blank?

        user = User.by_mobile(mobile)
        # 判断该用户是否存在
        raise_error 'user_not_found' if user.nil?

        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        raise_error 'password_not_match' unless salted_passwd.eql?(user.password)

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
