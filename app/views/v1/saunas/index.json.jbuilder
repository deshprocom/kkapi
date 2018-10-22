json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @saunas do |sauna|
      json.id         sauna.id
      json.logo       sauna.logo.url
      json.title      sauna.title
      json.location   sauna.location
      json.telephone  sauna.telephone
      json.star_level sauna.star_level
      json.distance   sauna.distance
      json.amap_navigation_url sauna.amap_navigation_url
    end
  end
end