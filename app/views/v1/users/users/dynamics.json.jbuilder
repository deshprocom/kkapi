json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @dynamics do |item|
      option_type = item.option_type
      json.option_type option_type

      if option_type.eql? 'follow'
        next json.partial! 'v1/briefs/base', model_type: 'user', target: @target_user
      end

      target = option_type.eql?('like') ? item.target : item.target.target
      target_type = target.class.to_s.tableize.singularize
      json.target_type target_type

      if option_type.eql? 'like'
        next json.partial! 'v1/briefs/base', model_type: target_type, target: target
      end

      if option_type.eql?('comment') || option_type.eql?('reply')
        model_name = item.target.class.to_s.tableize.singularize
        json.partial! 'v1/briefs/base', model_type: model_name, target: item.target
      end
      json.created_at item.created_at.to_i
    end
  end
end