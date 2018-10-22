json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.id          @activity.id
    json.banner      @activity.preview_image
    json.status      @activity.activity_status
    json.begin_time  @activity.begin_time.to_i
    json.end_time    @activity.end_time.to_i
    json.description @activity.description.to_s
    json.likes_count @activity.likes_count
    json.total_views @activity.total_views
    json.created_at  @activity.created_at.to_i
  end
end
