module V1
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      include UserAuthorize
      before_action :login_need?
      OPTION_TYPES = %w[register login reset_pwd change_pwd bind_account unbind_account
                        change_old_account bind_new_account bind_wx_account].freeze
      VCODE_TYPES = %w[mobile email].freeze

      def create
        # 验证码类型是否符合
        raise_error 'unsupported_type' unless params[:vcode_type].in?(VCODE_TYPES)
        raise_error 'unsupported_type' unless params[:option_type].in?(OPTION_TYPES)

        # 验证参数
        raise_error 'params_missing' if params[:account].blank?

        # 检查验证码是否正确
        raise_error 'vcode_not_match' unless VCode.check_vcode(params[:option_type], gain_account, params[:vcode])
        render_api_success
      end

      private

      def login_need?
        if params[:option_type].eql?('change_old_account')
          login_required
        else
          @current_user = nil
        end
      end

      def gain_account
        if params[:option_type].eql?('change_old_account')
          "+#{@current_user.ext}#{@current_user[params[:vcode_type]]}"
        else
          "+#{params[:ext]}#{params[:account]}"
        end
      end
    end
  end
end
