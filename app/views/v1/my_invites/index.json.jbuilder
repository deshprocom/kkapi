json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @invite_users.includes(:user) do |item|
      mark = item.user.new_user ? '(未完成)' : ''
      json.user_id   item.user.user_uuid
      json.nick_name "#{item.user.nick_name} #{mark}"
      json.avatar    item.user.avatar_path.to_s
    end
  end
  json.count @count
  json.next_step @current_user.r_level.eql?(1) # 只有1级用户才可查看indirect
end
