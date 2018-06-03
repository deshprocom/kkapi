module V1
  module Weixin
    class AuthController < ApplicationController
      before_action :set_wx_authorize

      def create
        raise_error 'weixin_auth_error' unless @wx_authorize.is_valid?
        @api_result = Services::Weixin::AuthService.call(user_params, @wx_authorize)
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['WX_APP_ID'], ENV['WX_APP_SECRET'])
      end

      def user_params
        params.permit(:code, :refresh_token)
      end
    end
  end
end
