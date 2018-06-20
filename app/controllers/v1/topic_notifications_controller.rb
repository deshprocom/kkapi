module V1
  class TopicNotificationsController < ApplicationController
    include UserAuthorize
    before_action :login_required

    def index
      @notifications = @current_user.topic_notifications
                                    .where.not(target_id: @current_user.id)
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(params[:page_size])
      # 将消息全部置为已读
      @notifications.each(&:read!)
    end

    def unread_count
      @unread_count = TopicNotification.where.not(target_id: @current_user.id).unread_count(@current_user)
    end

    def destroy
      @current_user.topic_notifications.find(params[:id]).destroy
      render_api_success
    end
  end
end
