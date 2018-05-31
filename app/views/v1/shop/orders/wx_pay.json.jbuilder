# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.appid     @prepay_result[:appid]
  json.partnerid @prepay_result[:partnerid]
  json.package   @prepay_result[:package]
  json.timestamp @prepay_result[:timestamp]
  json.prepayid  @prepay_result[:prepayid]
  json.noncestr  @prepay_result[:noncestr]
  json.sign      @prepay_result[:sign]
end
