json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @replies do |reply|
      json.partial! 'v1/replies/base', reply: reply
    end
  end
  json.replies_count @comment.replies_count
end