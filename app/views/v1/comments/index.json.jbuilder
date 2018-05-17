json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @comments do |comment|
      json.partial! 'v1/comments/base', comment: comment
    end
  end
  json.total_comments @target.total_comments
end