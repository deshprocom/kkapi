module V1
  module Weixin
    class BindController < ApplicationController
      ACCOUNT_TYPES = %w[mobile email].freeze
      before_action :set_wx_authorize

      def create
        user_params = permit_params.dup
        raise_error 'unsupported_type' unless ACCOUNT_TYPES.include?(user_params[:type])

        @api_result = Services::Weixin::BindService.call(user_params, @wx_authorize)
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['APP_ID'], ENV['APP_SECRET'])
      end

      def permit_params
        params.permit(:type, :account, :code, :access_token, :password)
      end
    end
  end
end

