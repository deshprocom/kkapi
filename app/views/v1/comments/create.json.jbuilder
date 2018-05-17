json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.partial! 'v1/comments/base', comment: @comment
end