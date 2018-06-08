module V1
  module Users
    class LikesController < ApplicationController
      include UserAuthorize
      before_action :user_self_required
      before_action :target, except: [:index]

      # 用户喜欢列表，keyword用来获取某个类别喜欢列表
      def index
        keyword = params[:keyword]
        @like_actions = @current_user.action_likes.page(params[:page]).per(params[:page_size])
                                    .yield_self { |it| keyword ? it.where(target_type: keyword.classify) : it }
      end

      # 说说长帖，资讯, 酒店..点赞
      def create
        @current_user.create_action(:like, target: @target)
        @current_user.dynamics.create(option_type: 'like', target: @target)
        TopicNotification.create(user: @target.user, target: @current_user, source: @target, notify_type: 'like') if topic?
      end

      # 取消点赞
      def cancel
        @current_user.destroy_action(:like, target: @target)
        @current_user.dynamics.find_by!(target: @target).destroy
        TopicNotification.where(notify_type: 'like', source: @target, target: @current_user).delete_all
      end

      private

      def target
        requires! :target_id
        requires! :target_type, values: %w[topic info hotel]
        @target = params[:target_type].classify.safe_constantize.find(params[:target_id])
      end

      def topic?
        params[:target_type].eql?('topic')
      end
    end
  end
end
