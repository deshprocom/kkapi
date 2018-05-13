json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @infos do |info|
      json.id      info.id
      json.title   info.title
      json.date    info.date
      json.image   info.preview_image
    end
  end
end