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
    end
  end
end

