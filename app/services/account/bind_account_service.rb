module Services
  module Account
    class BindAccountService
      include Serviceable

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        account = user_params[:account]
        type = user_params[:type]
        account_code = type.eql?('mobile') ? "+#{user_params[:ext]}#{account}" : account
        # 判断验证码是否匹配
        raise_error 'vcode_not_match' unless check_code('bind_account', account_code, user_params[:code])

        send("update_#{type}", account)
      end

      private

      def check_code(type, account, code)
        return true if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        VCode.check_vcode(type, account, code)
      end

      def update_mobile(mobile)
        # 判断手机号格式是否正确
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(mobile, user_params[:ext])
        # 判断账户是否存在
        raise_error 'mobile_already_used' if UserValidator.mobile_exists?(mobile)

        # 更新账户
        user.assign_attributes(mobile: mobile, ext: user_params[:ext])
        user.touch_visit!
        # 记录一次账户修改
        ApiResult.success_with_data(user: user)
      end

      def update_email(email)
        # 检查邮箱格式是否正确
        raise_error 'email_format_error' unless UserValidator.email_valid?(email)
        # 检查邮箱是否存在
        raise_error 'email_already_userd' if UserValidator.email_exists?(email)

        # 更新账户
        user.assign_attributes(email: email)
        user.touch_visit!
        # 记录一次账户修改
        ApiResult.success_with_data(user: user)
      end
    end
  end
end
