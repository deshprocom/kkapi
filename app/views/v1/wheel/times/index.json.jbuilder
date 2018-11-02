json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.id                   @wheel_time.id
  json.user_id              @current_user.user_uuid
  json.wheel_remain_times   @wheel_time.remain_times
  json.total_points         @current_user.counter.points
  json.today_invite_times   @current_user.wheel_task_counts&.find_by(date: Date.current)&.invite_count.to_i
  json.invite_limit_times         ENV['WHEEL_INVITE_LIMIT'].to_i
end