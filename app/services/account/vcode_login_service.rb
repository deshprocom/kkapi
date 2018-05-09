module Services
  module Account
    class VcodeLoginService
      include Serviceable

      attr_accessor :mobile, :vcode

      def initialize(mobile, vcode)
        self.mobile = mobile
        self.vcode = vcode
      end

      def call
        # 验证码或手机号是否为空
        raise_error 'params_missing' if mobile.blank? || vcode.blank?

        # 查询用户是否存在
        user = User.by_mobile(mobile)
        raise_error 'user_not_found' if user.nil?

        # 检查用户输入的验证码是否正确
        raise_error 'vcode_not_match' unless VCode.check_vcode('login', mobile, vcode)

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        access_token = UserToken.encode(user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
