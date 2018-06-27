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
        receive_time = Time.zone.now
        expire_time = receive_time + 30.days
        @coupon_temps.each do |item|
          Coupon.create(coupon_temp_id: item.id,
                        expire_day: 30,
                        expire_time: expire_time,
                        receive_time: receive_time,
                        user_id: @user.id)
        end
      end
    end
  end
end
