# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.items do
    # 自动生成模版
    # @certs.each do |item|
    #   json.set! item.first do
    #     json.array! item.second do |user_extra|
    #       json.partial! 'v1/users/user_extra', user_extra: user_extra
    #     end
    #   end
    # end
    json.chinese_ids do
      json.array! @certs['chinese_id'] do |user_extra|
        json.partial! 'v1/users/user_extra', user_extra: user_extra
      end
    end
    json.passport_ids do
      json.array! @certs['passport_id'] do |user_extra|
        json.partial! 'v1/users/user_extra', user_extra: user_extra
      end
    end
  end
end