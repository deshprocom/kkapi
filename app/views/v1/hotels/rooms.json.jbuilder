json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @rooms_with_prices do |obj|
      room = obj[:room]
      room_prices = obj[:room_prices]
      json.id     room.id
      json.title  room.title
      json.tags   room.tags
      json.notes  room.notes
      json.images room.images.map(&:original)

      json.prices do
        json.array! room_prices do |room_price|
          json.discount_amount HotelServices::MaxDiscount.call(@current_user, room_price.price)
          json.room_price_id   room_price.id
          json.saleable_num    room_price.saleable_num
          json.price           room_price.price.to_s
          json.is_official     room_price.sale_room_request_id.nil?
        end
      end
    end
  end
end