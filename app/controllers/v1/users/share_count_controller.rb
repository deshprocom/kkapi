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
        # 如果是新用户 做完分享活动可以获取奖励
        @current_user.take_pocket_moneys
        render_api_success
      end
    end
  end
end
