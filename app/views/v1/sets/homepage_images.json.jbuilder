json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.hotel_image @hotel_image
  json.cate_image @cate_image
  json.rate_image @rate_image
  json.recreation_image @recreation_image
end