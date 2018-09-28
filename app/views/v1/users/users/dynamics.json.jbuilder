json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @dynamics do |item|
      next unless item.view_visible?

      option_type = item.option_type
      next if option_type.eql? 'favorite'

      json.option_type option_type


      if option_type.eql? 'follow'
        json.partial! 'v1/briefs/base', model_type: 'user', target: item.target
        json.created_at item.created_at.to_i
        next
      end

      target = option_type.eql?('like') ? item.target : item.target.target
      target_type = target.class.to_s.tableize.singularize
      json.target_type target_type

      if option_type.eql? 'like'
        json.partial! 'v1/briefs/base', model_type: target_type, target: target
        json.created_at item.created_at.to_i
        next
      end

      if option_type.eql?('comment') || option_type.eql?('reply')
        model_name = item.target.class.to_s.tableize.singularize
        json.partial! 'v1/briefs/base', model_type: model_name, target: item.target
      end
      json.created_at item.created_at.to_i
    end
  end
end
