module HotelServices
  class CreateOrder
    include Serviceable

    attr_accessor :room, :order, :coupon
    def initialize(user, params, coupon_id)
      @user = user
      @checkin_infos = params.delete(:checkin_infos)
      @room = HotelRoom.published.find(params[:hotel_room_id])
      @room_price = HotelRoomPrice.find(params.delete :room_price_id)
      @order = HotelOrder.new(params)
      @coupon_id = coupon_id
      @room_prices = []
    end

    def call
      raise_error_msg('入住人信息数量应与房间数一致') if @checkin_infos.size != @order.room_num

      collect_room_items
      check_room_saleable!
      use_coupon!
      save_order
      update_coupon
      create_checkin_infos
      @order
    end

    def use_coupon!
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
      @order.room_items = (0...days_num).map { |i| room_item(i) }
      @order.total_price = @order.total_price_from_items
    end

    # 获取对应日期或默认的房间信息
    def room_item(i)
      date = @order.checkin_date + i.days
      if i == 0
        room_price = checkin_room_price(date)
      else
        # 找到相应日期或相应星期几的价格
        room_price = find_or_create_price(date)
      end
      @room_prices << room_price
      { date: date, price: room_price.price * @order.room_num, price_id: room_price.id }
    end

    def checkin_room_price(date)
      return @room_price unless @room_price.is_master

      find_or_create_price(date)
    end

    # 找到相应日期或者创建相应日期价格信息(创建时同步当天星期几价格信息的数据)
    def find_or_create_price(date)
      room_price = @room.prices.price_asc.find_by(date: date)
      return room_price if room_price

      create_date_price(date)
    end

    def create_date_price(date)
      wday_price = @room.wday_price(date.to_date)
      @room.prices.create(date: date,
                          price: wday_price.price,
                          room_num_limit: wday_price.room_num_limit,
                          hotel_id: @room.hotel_id)
    end

    # 购买的房间数量大于 最小的可购买数量 则不能购买
    def check_room_saleable!
      raise_error_msg('房间数量不足') if @order.room_num > min_saleable_num
    end

    # 所有日期中最小的可购买数量
    def min_saleable_num
      @min_saleable_num ||= @room_prices.map(&:saleable_num).min
    end
  end
end
