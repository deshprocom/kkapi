json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @like_actions do |action|
      model_name = action.target_type.tableize.singularize
      if action.target.present?
        json.target_type model_name
        json.partial! 'v1/briefs/base', model_type: model_name, target: action.target
      end
    end
  end
  json.likes_count @like_actions.count
end