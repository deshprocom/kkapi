module V1::Merchant
  class SaleRoomRequestController < MerchantApplicationController

    REQUIRES_CREATE_PARAMS = %w[hotel_id room_id room_num checkin_date price].freeze
    def create
      REQUIRES_CREATE_PARAMS.each { |param| requires! param }
    end
  end
end
