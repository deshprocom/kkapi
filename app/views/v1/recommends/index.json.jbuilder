json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.array! @recommends do |recommend|
      next if recommend.source.nil?

      json.source_type recommend.source_type
      json.partial!    'source', source: recommend.source
    end
  end
end
