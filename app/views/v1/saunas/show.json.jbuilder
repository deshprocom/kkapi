json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.sauna do
    json.id         @sauna.id
    json.logo       @sauna.logo.url
    json.title      @sauna.title
    json.location   @sauna.location
    json.telephone  @sauna.telephone
    json.star_level @sauna.star_level
    json.description @sauna.description
    json.amap_navigation_url @sauna.amap_navigation_url
  end
end