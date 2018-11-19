module V1
  class SetsController < ApplicationController
    before_action :set_visa
    before_action :set_homepage_images

    def index; end

    def set_visa
      @visa = Visa.first
    end

    def set_homepage_images
      @page_images = {
        hotel_image: 'https://cdn-upyun.deshpro.com/kk/uploads/sets/hotel.png',
        cate_image: 'https://cdn-upyun.deshpro.com/kk/uploads/sets/cate.png',
        rate_image: 'https://cdn-upyun.deshpro.com/kk/uploads/sets/rate.png',
        recreation_image: 'https://cdn-upyun.deshpro.com/kk/uploads/sets/recreation.png'
      }
    end
  end
end
