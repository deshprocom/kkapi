json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @coupons do |coupon|
      json.partial! 'v1/integral_malls/coupons/base', coupon: coupon
    end
  end
end