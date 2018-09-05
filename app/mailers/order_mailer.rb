class OrderMailer < ApplicationMailer
  # 酒店订单支付后，通知相应的员工
  def notify_hotel_staff(order)
    @order = order
    @room = order.hotel_room
    title = "用户购买了酒店：#{@room.hotel.title}"
    mail(to: ENV['HOTEL_STAFF_EMAILS'], subject: title)
  end

  def notify_shop_staff(order)
    @order = order
    @user = order.user
    user_info_string = "#{@user.nick_name} | #{@user.mobile} | #{@user.email}"
    title = "用户: #{user_info_string} 购买了商品"
    mail(to: ENV['SHOP_STAFF_EMAILS'], subject: title)
  end
end
