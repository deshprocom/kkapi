module V1
  module Account
    # 修改密码
    class ChangePasswordsController < ApplicationController
      CHANGE_PWD_TYPE = %w[vcode pwd].freeze
      include UserAuthorize
      before_action :user_self_required

      def create
        raise_error 'unsupported_type' unless user_params[:type].in?(CHANGE_PWD_TYPE)
        send("change_pwd_by_#{user_params[:type]}")
        render_api_success
      end

      private

      def change_pwd_by_vcode
        change_pwd_service = Services::Account::ChangePwdByVcodeService
        change_pwd_service.call(user_params, @current_user)
      end

      def change_pwd_by_pwd
        change_pwd_service = Services::Account::ChangePwdByPwdService
        change_pwd_service.call(user_params, @current_user)
      end

      def user_params
        params.permit(:type, :new_pwd, :old_pwd, :vcode, :mobile, :ext)
      end
    end
  end
end
