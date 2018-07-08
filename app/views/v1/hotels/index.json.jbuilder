json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @hotels do |hotel|
      json.id          hotel.id
      json.title       hotel.title
      json.location    hotel.location
      json.amap_poiid  hotel.amap_poiid
      json.logo        hotel.preview_logo
      json.star_level  hotel.star_level
      json.start_price hotel.start_price
      json.region      Hotel::REGIONS_MAP[hotel.region]
      json.amap_navigation_url hotel.amap_navigation_url
    end
  end
end