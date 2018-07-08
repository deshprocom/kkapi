module V1
  module Account
    # 负责登录相关的业务逻辑
    class SessionsController < ApplicationController
      LOGIN_TYPES = %w[email vcode mobile].freeze

      def create
        login_type = params[:type]
        raise_error 'unsupported_type' unless LOGIN_TYPES.include?(login_type)
        @api_result = send("login_by_#{login_type}")
      end

      private

      def login_by_vcode
        Services::Account::VcodeLoginService.call(params[:mobile], params[:vcode], params[:ext])
      end

      def login_by_email
        Services::Account::EmailLoginService.call(params[:email], params[:password])
      end

      def login_by_mobile
        Services::Account::MobileLoginService.call(params[:mobile], params[:password])
      end
    end
  end
end
