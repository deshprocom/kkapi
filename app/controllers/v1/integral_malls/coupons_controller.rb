module V1
  module IntegralMalls
    class CouponsController < ApplicationController
      include UserAuthorize
      before_action :set_coupon_temp, only: [:show, :exchange]
      before_action :login_required, only: [:exchange]

      def index
        @coupon_temps = CouponTemp.unclaimed.order(integrals: :asc).page(params[:page]).per(params[:page_size])
      end

      def show; end

      def exchange
        Services::Integrals::ExchangeCoupon.call(@current_user, @coupon_temp)
        render_api_success
      end

      private

      def set_coupon_temp
        @coupon_temp = CouponTemp.find(params[:id])
      end
    end
  end
end

