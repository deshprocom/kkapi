# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  type = @api_result.data[:type]
  data = @api_result.data[:data]
  json.type type
  json.info do
    json.partial! 'v1/users/user_base', user: data[:user] if type.eql?('login')
    json.access_token data[:access_token]
  end
end