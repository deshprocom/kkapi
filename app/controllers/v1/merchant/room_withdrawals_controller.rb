module V1::Merchant
  class RoomWithdrawalsController < MerchantApplicationController

    def create
      room_request = SaleRoomRequest.find(params[:request_id])
      return render_api_error('未卖出') unless room_request.is_sold
      return render_api_error('已提交申请') if room_request.room_request_withdrawal

      RoomRequestWithdrawal.create(sale_room_request: room_request,
                                   merchant_user: @current_user,
                                   price: room_request.price,
                                   status: 'pending')
      render_api_success
    end
  end
end
