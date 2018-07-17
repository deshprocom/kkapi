json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.login_days            @current_user.counter.login_days
  json.login_days_required   7
  json.share_count           @current_user.counter.share_count
  json.share_count_required  2
end