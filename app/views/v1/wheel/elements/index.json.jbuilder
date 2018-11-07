json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @elements do |element|
      json.id       element.id
      json.name     element.name
      json.position element.position
    end
  end
  json.wheel_image ENV['WHEEL_ELEMENT_IMAGE'].to_s
  json.prize_counts @elements.count
end