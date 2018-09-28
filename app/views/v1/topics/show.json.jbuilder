json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.partial! 'v1/topics/base_extra', topic: @topic
  json.current_user_liked @current_user&.find_action(:like, target: @topic).present?
  json.current_user_favorite @current_user.blank? ? false : @current_user.favorite?(@topic)
end