module HotelServices
  class CreateOrder
    include Serviceable

    attr_accessor :room, :order
    def initialize(user, params)
      @user   = user
      @checkin_infos = params.delete(:checkin_infos)
      @room = HotelRoom.find(params[:hotel_room_id])
      @order = HotelOrder.new(params)
    end

    def call
      raise_error_msg('入住人信息数量应与房间数一致') if @checkin_infos.size != @order.room_num
      save_order
      create_checkin_infos
      @order
    end

    def save_order
      collect_room_items
      @order.order_number = SecureRandom.hex(8)
      @order.status = 'unpaid'
      @order.pay_status = 'unpaid'
      @order.total_price = @order.total_price_from_items
      @order.final_price = @order.total_price
      @order.save
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
        room_price = @room.prices.find_by(date: date) || @room.master
        { date: date, price: room_price.price * @order.room_num }
      end
    end
  end
end
