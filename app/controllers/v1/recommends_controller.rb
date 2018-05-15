module V1
  class RecommendsController < ApplicationController
    def index
      @recommends = Recommend.position_desc.page(params[:page]).per(params[:page_size])
    end
  end
end