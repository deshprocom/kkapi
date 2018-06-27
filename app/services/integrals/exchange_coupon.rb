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

        receive_time = Time.zone.now
        expire_time = receive_time + @coupon.expire_day.day
        @coupon.update(receive_time: receive_time, expire_time: expire_time, user_id: @user.id)
        # 记录积分交易记录
        Integral.create(integral_create_params)
        # 扣除用户对应的积分
        @user.decrease_points(@coupon_temp.integrals)
        # 记录优惠券模版被领取的次数
        @coupon_temp.increment!(:coupon_received_count)
      end

      def integral_create_params
        {
          user_id: @user.id,
          option_type: 'exchange_coupon',
          target: @coupon,
          category: 'integral_mall',
          points: -@coupon_temp.integrals,
          mark: '积分换券',
          active_at: Time.zone.now
        }
      end
    end
  end
end
