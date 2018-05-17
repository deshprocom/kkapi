json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @followers do |user|
      json.partial! 'v1/users/user_brief', user: user
    end
  end
  json.followers_count @followers.count
end