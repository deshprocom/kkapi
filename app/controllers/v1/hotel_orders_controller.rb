module V1
  class HotelOrdersController < ApplicationController
    include UserAuthorize
    before_action :login_required

    # params
    # {
    #   "checkin_date": "2019-06-11",
    #   "checkout_date": "2019-06-13",
    #   "hotel_room_id": 33,
    #   "room_num": 1
    # }
    def new
      order_service = HotelServices::CreateOrder.new(@current_user, order_params)
      order_service.collect_room_items
      @order = order_service.order
      @room  = order_service.room
    end

    def order_params
      params.permit(:hotel_room_id, :checkin_date, :checkout_date, :room_num)
    end
  end
end
