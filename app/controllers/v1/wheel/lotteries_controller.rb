module V1
  module Wheel
    class LotteriesController < ApplicationController
      include UserAuthorize
      before_action :login_required
      include Signature
      before_action :signature_required

      # 用户点击转盘 开始抽奖
      def create
        @prize = ::Wheel::LotteryService.call(@current_user, params)
        # 次数统计
        WheelCount.wheel_total_count.increase_lottery_times
      end
    end
  end
end
