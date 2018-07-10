json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.partial! 'v1/integral_malls/coupons/tmp_base', resource: @coupon_temp
end
