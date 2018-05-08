# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.partial! 'v1/users/user_base', user: @api_result.data[:user]