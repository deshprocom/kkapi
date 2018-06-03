# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.id         @j_user.id
  json.username   @j_user.username
  json.nickname   @j_user.user.nick_name
  json.password   @j_user.password
  json.avatar     @j_user.user.avatar_path.to_s
  json.created_at @j_user.created_at.to_i
end
