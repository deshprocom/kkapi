module V1
  module Weixin
    class JsSignController < ApplicationController
      before_action :set_wx_authorize

      def create
        raise_error 'weixin_auth_error' unless @wx_authorize.is_valid?
        @sign_package = @wx_authorize.get_jssign_package(params[:url])
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['G_APP_ID'], ENV['G_APP_SECRET'])
      end
    end
  end
end

