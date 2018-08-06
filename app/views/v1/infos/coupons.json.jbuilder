json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @coupons do |coupon|
      json.id            coupon.id
      json.name          coupon.name
      json.short_desc    coupon.short_desc
      json.coupon_type   coupon.coupon_type
      json.discount_type coupon.discount_type
      json.reduce_price  coupon.reduce_price
      json.limit_price   coupon.limit_price
      json.discount      coupon.discount
      json.begin_date    coupon.begin_date
      json.end_date      coupon.end_date
      json.user_received Coupon.user_received?(@current_user.id, coupon.id)
    end
  end
end