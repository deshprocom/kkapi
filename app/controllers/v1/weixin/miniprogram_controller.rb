module V1
  module Weixin
    class MiniprogramController < ApplicationController

      def login
        # 保证先取到code，再拿到encrypted_data和iv
        # 否则解密时会报错 OpenSSL::Cipher::CipherError (bad decrypt)
        requires! :code
        requires! :encrypted_data
        requires! :iv
        @result = Services::Weixin::MiniprogramLogin.call(params)
      end

      def bind_mobile
        requires! :code
        requires! :account
        requires! :ext
        requires! :access_token
        uuid = UserToken.decode(params[:access_token])['user_uuid']
        wx_user = WeixinUser.find_by!(miniprogram_openid: uuid)
        @api_result = Services::Weixin::BindService.call(wx_user, params)
        render 'v1/weixin/bind/create'
      end
    end
  end
end

