# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.appId     @prepay_result[:appId]
  json.package   @prepay_result[:package]
  json.nonceStr   @prepay_result[:nonceStr]
  json.timeStamp   @prepay_result[:timeStamp]
  json.signType   @prepay_result[:signType]
  json.paySign   @prepay_result[:paySign]
end
