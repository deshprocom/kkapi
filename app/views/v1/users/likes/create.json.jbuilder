json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.total_likes @target.reload.likes_count
end