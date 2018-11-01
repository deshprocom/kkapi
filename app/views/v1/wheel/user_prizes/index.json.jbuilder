json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @prizes do |prize|
      json.id         prize.id
      json.prize      prize.memo.to_s
      json.created_at prize.created_at.to_i
    end
  end
end