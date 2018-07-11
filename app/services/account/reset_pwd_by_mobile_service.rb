module Services
  module Account
    class ResetPwdByMobileService
      include Serviceable

      attr_accessor :mobile, :vcode, :password, :ext

      def initialize(params)
        self.mobile = params[:mobile]
        self.ext = params[:ext]
        self.vcode = params[:vcode]
        self.password = params[:password]
      end

      def call # rubocop:disable Metrics/CyclomaticComplexity
        # 检查参数是否为空
        raise_error 'params_missing' if mobile.blank? || vcode.blank? || password.blank?

        # 检查密码是否符合规则
        raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(password)

        # 检查验证码是否正确
        raise_error 'vcode_not_match' unless VCode.check_vcode('reset_pwd', "+#{ext}#{mobile}", vcode)

        # 查询用户
        user = User.by_mobile(mobile)
        raise_error 'user_not_found' if user.nil?

        # 创建新的用户密码
        salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

        user.update(password: new_password, password_salt: salt)
        ApiResult.success_result
      end
    end
  end
end
