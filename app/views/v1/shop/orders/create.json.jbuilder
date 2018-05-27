json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.order_number order.order_number
end