module V1
  class SetsController < ApplicationController
    ALLOW_TYPES = %w[hotel_contacts visa homepage_images].freeze

    def index
      type = params[:type]
      raise_error 'unsupported_type' unless ALLOW_TYPES.include?(type)
      send("render_#{type}")
    end

    def render_hotel_contacts
      render 'hotel_contacts'
    end

    def render_visa
      render 'visa'
    end

    def render_homepage_images
      @hotel_image = 'https://cdn-upyun.deshpro.com/kk/uploads/sets/hotel.png'
      @cate_image = 'https://cdn-upyun.deshpro.com/kk/uploads/sets/cate.png'
      @rate_image = 'https://cdn-upyun.deshpro.com/kk/uploads/sets/rate.png'
      @recreation_image = 'https://cdn-upyun.deshpro.com/kk/uploads/sets/recreation.png'
      render 'homepage_images'
    end
  end
end
