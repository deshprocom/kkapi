module V1
  module Users
    class CouponsController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def search
        requires! :coupons_type
        requires! :amount

        @coupons = @current_user.coupons.includes(:coupon_temp).unused.order(expire_time: :asc)
        @coupons = @coupons.collect do |coupon|
          coupon_temp = coupon.coupon_temp
          next unless coupon_temp.coupon_type.eql?(params[:coupons_type])
          next if coupon_temp.discount_type.eql?('full_reduce') && coupon_temp.limit_price > params[:amount].to_f
          coupon
        end.compact
      end
    end
  end
end
