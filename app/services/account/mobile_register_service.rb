module Services
  module Account
    class MobileRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode, :password

      def initialize(params, remote_ip)
        self.mobile = params[:mobile]
        self.vcode = params[:vcode]
        self.password = params[:password]
        self.remote_ip = remote_ip || ''
      end

      def call
        # 检查手机格式是否正确
        raise_error mobile_format_error unless UserValidator.mobile_valid?(mobile)

        # 检查验证码是否正确
        raise_error vcode_not_match unless VCode.check_vcode('register', mobile, vcode)

        # 检查手机号是否存在
        raise_error mobile_already_used if UserValidator.mobile_exists?(mobile)

        # 检查密码是否合法
        raise_error password_format_wrong if password.present? && !UserValidator.pwd_valid?(password)
      end
    end
  end
end
