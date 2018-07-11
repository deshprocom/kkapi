json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.total_account @current_user.counter.total_pocket_money
end
