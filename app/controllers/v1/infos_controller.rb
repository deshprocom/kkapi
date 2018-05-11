module V1
  class HotelsController < ApplicationController
    before_action :set_type

    def index
      keyword = params[:keyword]
      @hotels = Hotel.user_visible.page(params[:page]).per(params[:page_size])
                  .yield_self { |it| keyword ? it.search_keyword(keyword) : it }
    end

    def show
      @hotel = Hotel.find(params[:id])
    end

    def set_type
      @type = InfoType.find_by!(slug: params[:info_type_id])
    end
  end
end
