json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.unread_count @unread_count
end