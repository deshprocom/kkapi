json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.mobile @contact&.mobile.to_s
  json.email @contact&.email.to_s
end