json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.total_invite_number @current_user.total_invite_count
  json.total_invite_money @current_user.total_invite_money
end
