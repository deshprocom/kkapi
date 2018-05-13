module V1
  class HotelsController < ApplicationController
    def index
      keyword = params[:keyword]
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
                     .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
    end

    def show
      @hotel = Hotel.find(params[:id])
    end
  end
end
