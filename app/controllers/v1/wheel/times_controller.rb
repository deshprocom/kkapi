module V1
  module Wheel
    class TimesController < ApplicationController
      include UserAuthorize
      before_action :login_required

      # 查看转盘剩余次数 及 用户剩余积分
      def index
        @wheel_time = @current_user.wheel_user_time
      end

      # 积分换取次数
      def create
        # 获取用户积分
        points_need = 200 # 200积分换取一次抽奖
        total_points = @current_user.counter.points
        raise_error 'wheel_integral_exchange_limit' if total_points < points_need

        Integral.create_integral_to_wheel_times(user: @current_user, points: -points_need)
        # 转盘的次数+1
        @current_user.wheel_user_time.increase_total_times
        render_api_success
      end
    end
  end
end
