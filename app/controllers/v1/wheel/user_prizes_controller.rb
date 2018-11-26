module V1
  module Wheel
    class UserPrizesController < ApplicationController
      include UserAuthorize
      before_action :login_required

      def index
        @prizes = @current_user.wheel_user_prizes
                               .where('prize_type != ?', 'free')
                               .order(created_at: :desc)
                               .page(params[:page]).per(params[:page_size])
      end

      def show
        @prize = @current_user.wheel_user_prizes.find(params[:id])
      end
    end
  end
end
