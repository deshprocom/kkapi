json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @hotels do |hotel|
      min_price = hotel.min_price(@date)
      json.id              hotel.id
      json.title           hotel.title
      json.location        hotel.location
      json.amap_poiid      hotel.amap_poiid
      json.logo            hotel.preview_logo
      json.star_level      hotel.star_level
      json.start_price     min_price
      json.discount_amount HotelServices::MaxDiscount.call(@current_user, min_price)
      json.region          Hotel::REGIONS_MAP[hotel.region]
      json.amap_navigation_url hotel.amap_navigation_url
      json.amap_location       hotel.amap_location
      json.favorites_count hotel.favorites_count
    end
  end
end