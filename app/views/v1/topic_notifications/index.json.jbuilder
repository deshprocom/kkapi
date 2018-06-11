json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do
  json.notifications do
    json.array! @notifications do |notification|
      next unless notification.view_visible?

      json.id            notification.id
      json.created_at    notification.created_at.to_i

      json.notify_type   notification.notify_type
      json.from do
        json.partial! 'v1/briefs/base', model_type: 'user', target: notification.target
      end

      json.to do
        json.partial! 'v1/briefs/base', model_type: 'user', target: notification.user
      end

      next if notification.notify_type.eql?('follow')

      model_type = notification.source_type.tableize.singularize

      json.partial! 'v1/briefs/base', model_type: model_type, target: notification.source
    end
  end
end
