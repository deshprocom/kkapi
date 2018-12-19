module V1
  module Weixin
    class BindController < ApplicationController
      ACCOUNT_TYPES = %w[mobile].freeze

      def create
        user_params = permit_params.dup
        raise_error 'unsupported_type' unless ACCOUNT_TYPES.include?(user_params[:type])

        # 从数据库找到该用户的记录
        wx_user = WeixinUser.find_by!(access_token: params[:access_token])
        @api_result = Services::Weixin::BindService.call(wx_user, user_params)
      end

      private
      def permit_params
        params.permit(:type, :account, :ext, :code, :access_token, :password)
      end
    end
  end
end

