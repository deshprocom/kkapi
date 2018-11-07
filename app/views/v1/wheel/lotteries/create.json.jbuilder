json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.id               @prize.id
  json.wheel_element_id @prize.wheel_element_id
  json.name             @prize.name
end