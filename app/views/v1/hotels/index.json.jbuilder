json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @hotels do |hotel|
      json.id        hotel.id
      json.title     hotel.title
      json.location  hotel.location
      json.logo      hotel.preview_logo
    end
  end
end