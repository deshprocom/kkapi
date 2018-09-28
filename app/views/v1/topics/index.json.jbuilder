json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @topics.includes(:user) do |topic|
      json.partial! 'v1/topics/base', topic: topic
      json.user do
        json.partial! 'v1/users/user_brief', user: topic.user
      end
      json.current_user_liked @current_user&.find_action(:like, target: topic).present?
      json.current_user_favorite @current_user.blank? ? false : @current_user.favorite?(topic)
    end
  end
end