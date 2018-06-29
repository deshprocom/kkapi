coupon_temp = coupon.coupon_temp
json.id                coupon_temp.id
json.coupon_number     coupon.coupon_number
json.coupon_type       coupon_temp.coupon_type
json.name              coupon_temp.name
json.cover_link        coupon_temp.preview_image
json.short_desc        coupon_temp.short_desc.to_s
json.begin_date        coupon.receive_time.strftime('%Y-%m-%d')
json.end_date          coupon.expire_time.strftime('%Y-%m-%d')
json.status            coupon.expired? ? 'expired' : coupon.coupon_status