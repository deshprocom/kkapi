json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @prizes do |prize|
      json.id           prize.id
      json.prize        prize.memo.to_s
      json.prize_img    prize.wheel_prize.image_url.to_s
      json.expired      prize.expired?
      json.used_time    prize.used_time
      json.used         prize.used
      json.pocket_money prize.wheel_prize.face_value.to_i > 0 && prize.prize_type.eql?('cheap')
      json.created_at   prize.created_at.to_i
    end
  end
end