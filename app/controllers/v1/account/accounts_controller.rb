module V10
  module Account
    # 处理注册相关的业务逻辑
    class AccountsController < ApplicationController
      ALLOW_TYPES = %w(email mobile).freeze

      def create
        register_type = params[:type]
        unless ALLOW_TYPES.include?(register_type)
          return render_api_error(I18n.t('errors.unsupported_type'))
        end
        send("register_by_#{register_type}")
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
        params.permit(:type, :email, :mobile, :password, :vcode)
      end
    end
  end
end
