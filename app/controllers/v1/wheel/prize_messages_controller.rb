module V1
  module Wheel
    class PrizeMessagesController < ApplicationController
      include UserAuthorize
      before_action :login_required

      def index
        # 轮播倒数5个奖品
        @prize_lists = WheelUserPrize.where.not(prize_type: 'free').order(id: :desc).limit(5)
      end

      def history
        @prize_lists = WheelUserPrize.where.not(prize_type: 'free').order(created_at: :desc).page(params[:page]).per(params[:page_size])
      end
    end
  end
end
