json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @hotlines do |hotline|
      json.id        hotline.id
      json.title     hotline.title
      json.telephone hotline.telephone
    end
  end
end