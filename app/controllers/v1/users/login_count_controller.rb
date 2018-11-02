module V1
  module Users
    class LoginCountController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def create
        # 访问次数 + 1
        @current_user.increase_login_count
        # 奖励积分给用户
        Services::Integrals::RecordService.call(@current_user, 'login')
        # 更新访问时间
        @current_user.touch_visit!
        # 如果是新用户 做完登录活动可以获取奖励
        @current_user.invite_user_completed_awards
        # 判断是否完成新手任务 下发奖励
        render_api_success
      end
    end
  end
end
