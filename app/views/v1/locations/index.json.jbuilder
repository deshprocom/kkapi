json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  base = @locations[:base] || {}
  json.base do
    json.city_name base[:cityname]
    json.geo_type base[:geo_type]
    json.next_page_token base[:next_page_token].to_s
  end
  json.nearbys do
    json.array! @locations[:nearbys] do |nearby|
      json.name       nearby[:name]
      json.address    nearby[:address]
      json.latitude   nearby[:latitude]
      json.longitude nearby[:longitude]
    end
  end
end
