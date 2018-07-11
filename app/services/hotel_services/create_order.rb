module HotelServices
  class CreateOrder
    include Serviceable

    attr_accessor :room, :order, :coupon
    def initialize(user, params, coupon_id)
      @user = user
      @checkin_infos = params.delete(:checkin_infos)
      @room = HotelRoom.published.find(params[:hotel_room_id])
      @order = HotelOrder.new(params)
      @coupon_id = coupon_id
    end

    def call
      raise_error_msg('入住人信息数量应与房间数一致') if @checkin_infos.size != @order.room_num

      collect_room_items
      use_coupon
      save_order
      update_coupon
      create_checkin_infos
      @order
    end

    def use_coupon
      return if @coupon_id.blank?

      @coupon = Coupon.find_by!(coupon_number: @coupon_id)
      raise_error_msg('优惠卷已过期') if @coupon.expired?
      raise_error_msg('优惠卷已被使用') if @coupon.coupon_status == 'used'
      raise_error_msg('不是酒店类型的优惠卷') unless @coupon.coupon_temp.coupon_type == 'hotel'
      raise_error_msg('优惠卷不符合折扣规则') unless @coupon.conform_discount_rules?(@order.total_price)

      @order.discount_amount = @coupon.discount_amount(@order.total_price).round(2)
    end

    def update_coupon
      @coupon && @coupon.update(target: @order, coupon_status: 'used', pay_time: Time.now)
    end

    def save_order
      @order.order_number = SecureRandom.hex(8)
      @order.user   = @user
      @order.status = 'unpaid'
      @order.pay_status = 'unpaid'
      final_price = @order.total_price - @order.discount_amount
      # 如果优惠金额大于总金额，则默认0.01
      @order.final_price = final_price.positive? ? final_price : 0.01
      raise_error_msg('系统错误：订单创建失败') unless @order.save
    end

    def create_checkin_infos
      @checkin_infos.each do |info|
        @order.checkin_infos.create(last_name: info[:last_name],
                                    first_name: info[:first_name])
      end
    end

    def collect_room_items
      days_num = (@order.checkout_date - @order.checkin_date).to_i
      @order.room_items = (0...days_num).map do |i|
        date = @order.checkin_date + i.days
        wday = HotelRoomPrice::WDAYS[date.wday]
        # 找到相应日期或相应星期几的价格
        room_price = @room.prices.find_by(date: date) || @room.send("#{wday}_price")
        { date: date, price: room_price.price * @order.room_num }
      end
      @order.total_price = @order.total_price_from_items
    end
  end
end
