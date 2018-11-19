module V1
  class SetsController < ApplicationController
    ALLOW_TYPES = %w[hotel_contacts visa].freeze

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
  end
end
