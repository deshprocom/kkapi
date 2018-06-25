json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do # rubocop:disable Metrics/BlockLength
  json.room do
    json.id     @order.hotel_room.id
    json.title  @order.hotel_room.title
    json.tags   @order.hotel_room.tags
    json.notes  @order.hotel_room.notes
    json.images @order.hotel_room.images.map(&:original)
  end

  json.order do
    json.order_number    @order.order_number
    json.telephone       @order.telephone
    json.status          @order.status
    json.pay_status      @order.pay_status
    json.status_text     @order.status_text
    json.refundable      @order.refundable?
    json.room_num        @order.room_num
    json.final_price     @order.final_price
    json.total_price     @order.total_price
    json.refund_price    @order.refund_price
    json.discount_amount @order.discount_amount
    json.checkin_date    @order.checkin_date
    json.checkout_date   @order.checkout_date
    json.room_items      @order.room_items
    json.created_at      @order.created_at.to_i
    json.nights_num      @order.nights_num
  end

  json.checkin_infos do
    json.array! @order.checkin_infos, :last_name, :first_name
  end

  if @order.recent_refund
    json.recent_refund do
      json.extract! @order.recent_refund, :admin_memo, :memo, :refund_price
    end
  end
end
