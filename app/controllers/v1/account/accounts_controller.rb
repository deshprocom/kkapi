module V1
  module Account
    # 处理注册相关的业务逻辑
    class AccountsController < ApplicationController
      ALLOW_TYPES = %w[email mobile].freeze

      def create
        register_type = params[:type]
        raise_error 'unsupported_type' unless ALLOW_TYPES.include?(register_type)
        send("register_by_#{register_type}")
      end

      def verify
        account = params[:account]
        @flag = UserValidator.mobile_exists?(account) || UserValidator.email_exists?(account)
      end

      private

      def register_by_mobile
        mobile_register_service = Services::Account::MobileRegisterService
        @api_result = mobile_register_service.call(user_params)
      end

      def register_by_email
        email_register_service = Services::Account::EmailRegisterService
        @api_result = email_register_service.call(user_params)
      end

      def user_params
        # params.permit(:type, :email, :mobile, :password, :vcode)
        # 屏蔽邮箱注册
        params.permit(:type, :mobile, :password, :vcode, :invite_code, :ext)
      end
    end
  end
end
