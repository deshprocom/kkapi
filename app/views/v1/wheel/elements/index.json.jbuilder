json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @elements do |element|
      json.id   element.id
      json.name element.name
    end
  end
end