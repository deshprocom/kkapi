module V1
  module Users
    class ShareCountController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def create
        # 分享次数 + 1
        @current_user.increase_share_count
        # 奖励积分给用户
        Services::Integrals::RecordService.call(@current_user, 'share')
        render_api_success
      end
    end
  end
end
