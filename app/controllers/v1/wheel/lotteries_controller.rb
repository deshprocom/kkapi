module V1
  module Wheel
    class LotteriesController < ApplicationController
      include UserAuthorize
      before_action :login_required

      # 用户点击转盘 开始抽奖
      def create
        @prize = ::Wheel::LotteryService.call(@current_user, params)
      end
    end
  end
end
