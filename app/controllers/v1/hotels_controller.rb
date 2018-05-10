module V1
  class HotelsController < ApplicationController
    def index
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
    end

    def show
      @hotel = Hotel.find(params[:id])
    end
  end
end
