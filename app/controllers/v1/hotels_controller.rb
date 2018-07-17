module V1
  class HotelsController < ApplicationController
    before_action :set_hotel, only: [:show, :rooms]

    def index
      keyword = params[:keyword].presence
      region = params[:region].presence
      order = params[:order].presence
      @date = params[:date].presence ? params[:date].to_date : Date.current
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
                     .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
                     .yield_self { |it| region ? it.where_region(region) : it }
                     .yield_self { |it| order == 'price_desc' ? it.price_desc(@date) : it }
                     .yield_self { |it| order == 'price_asc' ? it.price_asc(@date) : it }
                     .position_desc
    end

    def show; end

    def rooms
      requires! :date
      @date = params[:date].to_date
      @rooms = @hotel.published_rooms.includes(:images, HotelRoom.s_wday_price(@date))
      @prices = HotelRoomPrice.where(hotel_room_id: @rooms.map(&:id),
                                     date: params[:date],
                                     is_master: false)
    end

    def regions; end

    def set_hotel
      @hotel = Hotel.find(params[:id])
    end
  end
end
