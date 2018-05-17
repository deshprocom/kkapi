module V1
  class CommentsController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :set_comment, except: [:index, :create]
    before_action :target, only: [:index, :create]
    before_action :body_valid?, only: [:create]

    def index
      @comments = @target.comments.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    def create
      @comment = Comment.create(user: @current_user,
                                target: @target,
                                body: params[:body])
      @current_user.dynamics.create(option_type: 'comment', target: @comment)
    end

    def replies
      @replies = @comment.replies.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    def destroy
      @comment.destroy!
      render_api_success
    end

    private

    def target
      requires! :target_id
      requires! :target_type, values: %w[topic info hotel]
      @target = params[:target_type].classify.safe_constantize.find(params[:target_id])
    end

    def body_valid?
      requires! :body
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
end
