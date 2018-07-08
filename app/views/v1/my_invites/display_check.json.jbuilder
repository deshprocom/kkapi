json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.display @current_user.r_level.eql?(1) || @current_user.r_level.eql?(2) # 只有1级和2级用户才可查看
end
