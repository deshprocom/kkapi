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
        @current_user.invite_user_completed_awards
        # 如果分享的活动来自于 活动大转盘分享，那么会给用户增加奖励机会
        WheelTaskCount.award_times_from_share(@current_user) if params[:from].eql?('wheel')
        render_api_success
      end
    end
  end
end
