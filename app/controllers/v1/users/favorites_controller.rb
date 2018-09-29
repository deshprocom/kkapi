module V1
  module Users
    class FavoritesController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        keyword = params[:keyword]
        @favorites_actions = @current_user.action_favorites.page(params[:page]).per(params[:page_size])
                                          .yield_self { |it| keyword ? it.where(target_type: keyword.classify) : it }
      end

      def create
        raise_error 'already_favorite' if @current_user.favorite?(target)
        @current_user.favorite(target)
        @current_user.dynamics.create(option_type: 'favorite', target: @target)
      end

      def cancel
        @current_user.unfavorite(target)
        @current_user.dynamics.find_by!(target: @target).destroy
      end

      private

      def target
        requires! :target_id
        requires! :target_type, values: %w[topic info hotel]
        @target = params[:target_type].classify.safe_constantize.find(params[:target_id])
      end
    end
  end
end
