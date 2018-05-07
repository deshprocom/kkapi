module UserAuthorize
  extend ActiveSupport::Concern
  included do
    before_action :user_authenticate!
  end

  def http_token
    @http_token ||= request.headers['HTTP_X_ACCESS_TOKEN']
  end

  def user_authenticate!
    @user_authenticate ||= UserToken.decode(http_token) || render_authenticate_failed
  end

  def login_required
    current_user || render_login_failed
  end

  def user_self_required
    verified = @current_user.present? && @current_user.user_uuid.eql?(params[:user_id])
    render_not_user_self unless verified
  end

  def current_user
    user_uuid = @user_authenticate[:user_uuid]
    @current_user ||= User.by_uuid(user_uuid)
  end

  def render_authenticate_failed
    render json: { error: 'Unauthorized', message: I18n.t('errors.invalid_credential') }, status: :unauthorized
  end

  def render_login_failed
    render json: { error: 'Unauthorized', message: I18n.t('errors.login_required') }, status: :unauthorized
  end

  def render_not_user_self
    render json: { error: 'Unauthorized', message: I18n.t('errors.user_self_required') }, status: :unauthorized
  end
end