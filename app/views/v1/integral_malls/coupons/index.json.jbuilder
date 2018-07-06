json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @coupon_temps do |item|
      json.partial! 'v1/integral_malls/coupons/tmp_base', resource: item
    end
  end
end
