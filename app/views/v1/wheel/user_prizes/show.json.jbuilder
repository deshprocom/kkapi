json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.id           @prize.id
  json.prize        @prize.memo.to_s
  json.prize_img    @prize.wheel_prize.image_url.to_s
  json.expired      @prize.expired?
  json.description  @prize.wheel_prize.description.to_s
  json.pocket_money @prize.pocket_money?
  json.created_at   @prize.created_at.to_i
end