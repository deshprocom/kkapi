module V1
  class BannersController < ApplicationController
    def index
      @banners = Banner.position_desc.limit(10)
    end
  end
end