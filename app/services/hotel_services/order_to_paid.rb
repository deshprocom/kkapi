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
      notify_dingtalk
      OrderMailer.notify_hotel_staff(@order).deliver_later
    end

    def notify_dingtalk
      checkin_infos = @order.checkin_infos.map {|info| "#{info.last_name} #{info.first_name}"}.join(', ')
      text = "#{@room.hotel&.title} - #{@room.title}\n
房间数量：#{@order.room_num}间\n
入住日期：#{@order.checkin_date} - #{@order.checkout_date}\n
入住人信息：#{checkin_infos}\n
联系方式：#{@order.telephone}\n
支付金额：#{@order.final_price}元\n
支付渠道：#{@order.pay_channel_text}"
      DingtalkApi.hotel_order_notify(text)
    end

    # 付款成功，更新每日房间已卖出的数量
    def update_sales_room
      @order.room_items.each do |item|
        room_price = HotelRoomPrice.find(item['price_id'])
        room_price.increase_sales(@order.room_num)
        room_price.sale_room_request&.to_sold
      end
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
