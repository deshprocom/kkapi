module V1
  module Account
    class CouponsController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        keyword = params[:keyword] # 未使用unused, 已过期used
        @coupons =
          case keyword
          when 'unused' then @current_user.coupons.unused
          when 'used' then @current_user.coupons.used
          else @current_user.coupons
          end
        @coupons = @coupons.order(receive_time: :desc).page(params[:page]).per(params[:page_size])
      end

      def show
        @coupon = @current_user.coupons.find_by!(coupon_number: params[:id])
      end
    end
  end
end
