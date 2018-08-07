json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @traders do |trader|
      user = trader.user
      json.score     trader.score
      json.user_id   user.user_uuid
      json.nick_name user.nick_name
      json.mobile    user.mobile
      json.avatar    user.avatar_path.to_s
      json.signature user.signature.to_s
    end
  end
end