json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @orders do |order|
      json.order do
        json.order_number    order.order_number
        json.status          order.status
        json.pay_status      order.pay_status
        json.status_text     order.status_text
        json.refundable      order.refundable?
        json.room_num        order.room_num
        json.final_price     order.final_price
        json.total_price     order.total_price
        json.discount_amount order.discount_amount
        json.checkin_date    order.checkin_date
        json.checkout_date   order.checkout_date
        json.nights_num      order.nights_num
      end

      json.room_title  order.hotel_room.title
      json.hotel_title order.hotel_room.hotel.title
      json.hotel_logo  order.hotel_room.hotel.preview_logo
    end
  end
end
