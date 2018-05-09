module Services
  module Account
    class EmailLoginService
      include Serviceable

      attr_accessor :email, :password

      def initialize(email, password)
        self.email = email.downcase
        self.password = password
      end

      def call
        # 验证密码和邮箱是否为空
        raise_error 'params_missing' if email.blank? || password.blank?

        user = User.by_email(email)
        # 判断该用户是否存在
        raise_error 'user_not_found' if user.nil?

        # 查询出了这个用户 对比密码
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
