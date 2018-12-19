# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.status @result[:status]
  json.access_token @result[:access_token]
  json.user do
    json.partial! 'v1/users/user_base', user: @result[:user] if @result[:status].eql?('login_success')
  end
end