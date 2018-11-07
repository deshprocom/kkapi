json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.user_id              @current_user.user_uuid
  json.total_points         @current_user.counter.points
  json.today_invite_times   @wheel_task_count&.invite_count.to_i
  json.invite_limit_times   ENV['WHEEL_INVITE_LIMIT'].to_i
  json.today_share_times    @wheel_task_count&.share_count.to_i
  json.share_limit_times    ENV['WHEEL_SHARE_LIMIT'].to_i
  json.activity_id          Activity.wheel.first&.id.to_i
end