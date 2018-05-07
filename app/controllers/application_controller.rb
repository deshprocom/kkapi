class ApplicationController < ActionController::API
  rescue_from(ActiveRecord::RecordNotFound) do
    render json: { error: I18n.t('errors.record_not_found') }, status: 404
  end

  def render_api_error(msg, code = 1)
    render 'common/basic', locals: { api_result: ApiResult.error_result(msg, code) }
  end

  def render_api_success
    render 'common/basic', locals: { api_result: ApiResult.success_result }
  end
end
