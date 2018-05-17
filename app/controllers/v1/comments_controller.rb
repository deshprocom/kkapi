module V1
  class CommentsController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :target, except: [:destroy]
    before_action :body_valid?, only: [:create]

    def create
      @comment = Comment.create(user: @current_user,
                                target: @target,
                                body: params[:body])
      @current_user.dynamics.create(option_type: 'comment', target: @comment)
    end

    def destroy
      Comment.find(params[:id]).destroy!
      render_api_success
    end

    private

    def target
      requires! :target_id
      requires! :target_type, values: %w[topic]
      @target = params[:target_type].classify.safe_constantize.find(params[:target_id])
    end

    def body_valid?
      requires! :body
    end
  end
end
