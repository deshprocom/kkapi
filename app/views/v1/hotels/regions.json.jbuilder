json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! Hotel::REGIONS_MAP.to_a do |regoin|
      json.id   regoin[0]
      json.name regoin[1]
    end
  end
end