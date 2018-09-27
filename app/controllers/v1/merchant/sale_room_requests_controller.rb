module V1::Merchant
  class SaleRoomRequestsController < MerchantApplicationController
    before_action :set_sale_request, only: [:update, :cancel]

    REQUIRES_CREATE_PARAMS = %w[hotel_id room_id room_num checkin_date price card_img].freeze
    def create
      REQUIRES_CREATE_PARAMS.each { |param| requires! param }
      request = @current_user.sale_room_requests.build(request_params)
      if request.save
        Services::Merchants::SaleRoomSms.call(@current_user, request_params) unless ENV['SALE_ROOM_SMS_URI'].blank?
        render_api_success
      else
        render_api_error("创建失败: #{request.errors.full_messages.join(',')}")
      end
    end

    REQUEST_TYPES =  %w[pending passed refused on_offer sold unsold].freeze
    def index
      requires! :request_type, values: REQUEST_TYPES
      @requests = @current_user.sale_room_requests
                    .send(params[:request_type])
                    .includes(:hotel, :hotel_room)
                    .page(params[:page]).per(params[:page_size])
    end

    def update
      requires! :price
      @sale_request.update(price: params[:price])
      if !@sale_request.is_sold
        @sale_request.hotel_room_price&.destroy
        @sale_request.create_room_price
      end
      render_api_success
    end

    def cancel
      if @sale_request.can_cancel?
        @sale_request.canceled!
        render_api_success
        @sale_request.hotel_room_price&.destroy
      else
        render_api_error('目前状态不允许取消')
      end
    end

    def set_sale_request
      @sale_request = SaleRoomRequest.find(params[:id])
    end

    def request_params
      params.permit(:hotel_id,
                    :room_id,
                    :room_num,
                    :checkin_date,
                    :card_img,
                    :price)
    end
  end
end
