json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.mobile ENV['HOTEL_APP_MOBILE']
end