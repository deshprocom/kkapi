json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @coupons do |item|
      coupon_temp = item.coupon_temp
      json.id                coupon_temp.id
      json.coupon_type       coupon_temp.coupon_type
      json.name              coupon_temp.name
      json.cover_link        coupon_temp.preview_image
      json.short_desc        coupon_temp.short_desc.to_s
      json.begin_date        item.receive_time.strftime('%Y-%m-%d')
      json.end_date          item.expire_time.strftime('%Y-%m-%d')
    end
  end
end