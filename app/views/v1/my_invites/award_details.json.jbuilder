json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @pocket_moneys do |item|
      json.memo       item.invite_memo
      json.amount     item.amount
      json.created_at item.created_at.to_i
    end
  end
end
