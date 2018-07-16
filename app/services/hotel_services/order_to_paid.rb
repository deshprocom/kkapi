module HotelServices
  class OrderToPaid
    include Serviceable

    def initialize(order, pay_channel)
      @order = order
      @room = order.hotel_room
      @pay_channel = pay_channel
    end

    def call
      update_order
      notify_after_paid
      update_sales_room
    end

    def update_order
      @order.status = 'paid' if @order.unpaid?
      @order.pay_status = 'paid' if @order.pay_status == 'unpaid'
      @order.pay_channel = @pay_channel
      @order.save
    end

    def notify_after_paid
      notify_user_after_paid
      OrderMailer.notify_staff_after_paid(@order).deliver_later
    end

    # 付款成功，更新每日房间已卖出的数量
    def update_sales_room
      @order.room_items.each do |item|
        find_or_create_price(item['date']).increase_sales(@order.room_num)
      end
    end

    # 找到相应日期或者创建相应日期价格信息(创建时同步当天星期几价格信息的数据)
    def find_or_create_price(date)
      room_price = @room.prices.find_by(date: date)
      return room_price if room_price

      wday_price = @room.wday_price(date.to_date)
      @room.prices.create(date: date,
                          price: wday_price.price,
                          room_num_limit: wday_price.room_num_limit,
                          hotel_id: @room.hotel_id)
    end

    # "[澳门旅行]预定成功:澳门金沙城中心假日酒店7月14日入住假日高级房2间1晚，入住人请携带有效证件及入境标签联系客服：#{ENV['HOTEL_STAFF_TEL']}办理入住。"
    NOTICE_USER_AFTER_PAID_SMS = "[澳门旅行]预定成功:%s，入住人请携带有效证件及入境标签联系客服: #{ENV['HOTEL_STAFF_TEL']} 办理入住。"
    def notify_user_after_paid
      # 酒店订单支付后，短信通知用户
      date = @order.checkin_date.strftime('%m月%d日')
      hotel = @room.hotel
      title = "#{hotel.title}#{date}入住#{@room.title}#{@order.room_num}间#{@order.nights_num}晚"
      sms_content = format(NOTICE_USER_AFTER_PAID_SMS, title)
      SendMobileIsmsJob.perform_later(@order.telephone, sms_content)
    end
  end
end
