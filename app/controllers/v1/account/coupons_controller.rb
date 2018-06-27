module V1
  module Account
    class CouponsController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        @coupons = @current_user.coupons.order(close_time: :asc).order(receive_time: :desc).page(params[:page]).per(params[:page_size])
      end
    end
  end
end
