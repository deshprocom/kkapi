module V1
  module Users
    class FollowingController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      # 获取关注列表
      def index
        @followings = @current_user.follow_users
      end

      # 关注某人
      def create
        @target_user = User.find_by!(user_uuid: params[:target_id])
        raise_error 'cannot_follow_self' if @current_user.eql?(@target_user)
        @current_user.create_action(:follow, target: @target_user)
        @current_user.dynamics.create(option_type: 'follow', target: @target_user)
        TopicNotification.create(user_id: @target_user.id, target: @current_user, notify_type: 'follow')
        render_api_success
      end

      # 取消关注某人
      def destroy
        @target_user = User.find_by!(user_uuid: params[:id])
        @current_user.destroy_action(:follow, target: @target_user)
        @current_user.dynamics.find_by!(target: @target_user).destroy
        TopicNotification.where(notify_type: 'follow', target: @current_user).delete_all
        render_api_success
      end

      def uids
        @uids = User.find(@current_user.follow_user_ids).pluck(:user_uuid)
      end
    end
  end
end
