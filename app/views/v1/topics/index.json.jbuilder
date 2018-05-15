json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @topics.includes(:user) do |topic|
      json.partial! 'v1/topics/base', topic: topic
      json.user do
        json.partial! 'v1/users/user_brief', user: topic.user
      end
    end
  end
end