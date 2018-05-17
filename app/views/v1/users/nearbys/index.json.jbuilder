json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @nearby_users do |user|
      json.partial! 'v1/users/user_brief', user: user
      json.distance user.distance
    end
  end
end