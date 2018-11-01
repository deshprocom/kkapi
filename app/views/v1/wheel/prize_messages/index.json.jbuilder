json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @prize_lists do |item|
      json.id         item.id
      json.user_id    item.user.user_uuid
      json.nick_name  item.user.nick_name.to_s
      json.prize      item.memo.to_s
      json.created_at item.created_at.to_i
    end
  end
end