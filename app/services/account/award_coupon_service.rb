module Services
  module Account
    class AwardCouponService
      include Serviceable

      def initialize(user)
        @user = user
      end

      def call
        award_new_user
      end

      private

      def award_new_user
        @coupon_temps = CouponTemp.published.new_user
        @coupon_temps.each do |item|
          Coupon.create(coupon_temp_id: item.id).received_by_user(@user)
        end
      end
    end
  end
end
