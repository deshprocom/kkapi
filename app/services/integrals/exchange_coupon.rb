module Services
  module Integrals
    class ExchangeCoupon
      include Serviceable

      def initialize(user, coupon_temp)
        @user = user
        @coupon_temp = coupon_temp
      end

      def call
        # 判断库存是否有可领取的
        raise_error 'under_stock' unless @coupon_temp.claim?
        # 判断用户的积分是否可以兑换
        raise_error 'under_integral' if @user.counter.points < @coupon_temp.integrals
        # 可领取，那么找出一张优惠券 跟这个用户进行绑定
        @coupon = @coupon_temp.coupons.unclaimed.first
        raise_error 'under_stock' if @coupon.blank?

        @coupon.received_by_user(@user)
        # 记录积分交易记录
        Integral.create_integral_to_coupon(user: @user, target: @coupon, points: -@coupon_temp.integrals)
        # 记录优惠券模版被领取的次数
        @coupon_temp.increment!(:coupon_received_count)
      end
    end
  end
end
