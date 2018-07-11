json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @details do |item|
      json.memo       item.memo
      json.amount     item.amount
      json.created_at item.created_at.to_i
    end
  end
  json.total_account @current_user.counter.total_pocket_money
end
