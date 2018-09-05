json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.items do
    json.array! @requests do |request|
      json.id             request.id
      json.hotel_title    request.hotel.title
      json.room_title     request.hotel_room.title
      json.room_num       request.room_num
      json.card_img       request.card_img.url
      json.checkin_date   request.checkin_date
      json.status         request.status
      json.is_sold        request.is_sold
      json.is_withdrawn   request.is_withdrawn
      json.created_at     request.created_at
      json.passed_time    request.passed_time
      json.withdrawn_time request.withdrawn_time
      json.refused_memo   request.refused_memo
    end
  end
end