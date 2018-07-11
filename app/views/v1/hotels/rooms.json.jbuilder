json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @rooms do |room|
      json.id     room.id
      json.title  room.title
      json.tags   room.tags
      json.notes  room.notes
      json.images room.images.map(&:original)

      room_price = @prices.find { |p| p.hotel_room_id == room.id } || room.master
      json.price room_price.price
    end
  end
end