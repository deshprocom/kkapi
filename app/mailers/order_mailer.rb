class OrderMailer < ApplicationMailer
  # 酒店订单支付后，通知相应的员工
  default to: ENV['HOTEL_STAFF_EMAILS']
  def notice_staff_after_paid(order)
    @order = order
    @room = order.hotel_room
    title = "用户#{order.telephone}: 已购买 #{@room.hotel.title}-#{@room.title}"
    mail(subject: title)
  end
end
