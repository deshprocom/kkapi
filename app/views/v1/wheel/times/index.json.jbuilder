json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.id                   @wheel_time.id
  json.user_id              @current_user.user_uuid
  json.wheel_remain_times   @wheel_time.remain_times
end