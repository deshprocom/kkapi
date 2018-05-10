module V1
  class HotelsController < ApplicationController
    def index
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
    end
  end
end
