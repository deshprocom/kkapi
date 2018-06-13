module HotelServices
  class CreateOrder
    include Serviceable

    attr_accessor :room, :order
    def initialize(user, params)
      @user   = user
      @params = params
      @room = HotelRoom.find(params[:hotel_room_id])
      @order = HotelOrder.new(params)
    end

    def collect_room_items
      days_num = (@order.checkout_date - @order.checkin_date).to_i
      @order.room_items = (0...days_num).map do |i|
        date = @order.checkin_date + i.days
        room_price = @room.prices.find_by(date: date) || @room.master
        { date: date, price: room_price.price * @order.room_num }
      end
    end
  end
end
