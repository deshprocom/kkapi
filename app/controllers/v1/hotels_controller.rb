module V1
  class HotelsController < ApplicationController
    before_action :set_hotel, only: [:show, :rooms]

    def index
      keyword = params[:keyword]
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
                     .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
    end

    def show; end

    def rooms
      requires! :date
      @rooms = @hotel.published_rooms.includes(:master, :images)
      @prices = HotelRoomPrice.where(hotel_room_id: @rooms.map(&:id),
                                     date: params[:date],
                                     is_master: false)
    end

    def set_hotel
      @hotel = Hotel.find(params[:id])
    end
  end
end
