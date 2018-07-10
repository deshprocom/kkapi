module V1
  module Account
    # 个人中心 个人信息部分
    class ProfilesController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def show; end

      def update
        illegal_keyword_check! :nick_name
        illegal_keyword_check! :signature
        @current_user.assign_attributes(user_params)
        @current_user.touch_visit!
        render :show
      end

      private

      def user_params
        params.permit(:nick_name, :gender, :birthday, :signature)
      end
    end
  end
end
