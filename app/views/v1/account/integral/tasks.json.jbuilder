json.partial! 'common/basic', api_result: ApiResult.success_result

json.data do
  json.items do
    json.unfinished do
      json.array! @result[false] do |result|
        json.option_type         result[:option_type]
        json.mark                result[:mark]
        json.doing_times         result[:doing]
        json.done_times          result[:done]
        json.total_doing_points  result[:total_doing_points]
        json.total_done_points   result[:total_done_points]
        json.limit_times         result[:limit_times]
      end
    end

    json.finished do
      json.array! @result[true] do |result|
        json.option_type         result[:option_type]
        json.mark                result[:mark]
        json.doing_times         result[:doing]
        json.done_times          result[:done]
        json.total_doing_points  result[:total_doing_points]
        json.total_done_points   result[:total_done_points]
        json.limit_times         result[:limit_times]
      end
    end
  end
end