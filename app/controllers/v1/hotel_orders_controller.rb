module V1
  class HotelOrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required

    # params
    # {
    #   "checkin_date": "2018-06-11",
    #   "checkout_date": "2018-06-13",
    #   "hotel_room_id": 33,
    #   "room_num": 1
    # }
    def new
      order_service = HotelServices::CreateOrder.new(@current_user, order_params)
      order_service.collect_room_items
      @order = order_service.order
      @room  = order_service.room
    end

    # params
    # {
    #   "checkin_date":"2018-06-11",
    #   "checkout_date":"2018-06-13",
    #   "hotel_room_id":33,
    #   "room_num":2,
    #   "telephone":"13428722299",
    #   "checkin_infos":[
    #      {"last_name":"杨", "first_name":"先生"},
    #      {"last_name":"黄", "first_name":"先生"}
    #    ]
    # }
    def create
      @order = HotelServices::CreateOrder.call(@current_user, order_params)
    end

    def index
      @orders = @current_user.hotel_orders.includes(hotel_room: [:hotel])
    end

    def order_params
      params.permit(:hotel_room_id, :checkin_date, :checkout_date,
                    :room_num, :telephone, checkin_infos: [:last_name, :first_name])
    end
  end
end
