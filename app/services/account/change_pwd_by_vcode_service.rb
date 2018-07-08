module Services
  module Account
    class ChangePwdByVcodeService
      include Serviceable

      attr_accessor :new_pwd, :mobile, :vcode, :user, :ext

      def initialize(params, user)
        self.new_pwd = params[:new_pwd]
        self.mobile = params[:mobile]
        self.ext = params[:ext]
        self.vcode = params[:vcode]
        self.user = user
      end

      def call
        # 检查密码是否为空
        raise_error 'params_missing' if vcode.blank? || mobile.blank? || new_pwd.blank?

        # 检查密码是否太简单
        raise_error 'password_format_wrong' unless UserValidator.pwd_valid?(new_pwd)

        # 判断验证码是否一致
        raise_error 'vcode_not_match' unless VCode.check_vcode('change_pwd', "+#{ext}#{mobile}", vcode)

        # 生成新的密码 设置新的盐值
        new_salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{new_pwd}#{new_salt}")

        user.update(password: new_password, password_salt: new_salt)
        ApiResult.success_result
      end
    end
  end
end
