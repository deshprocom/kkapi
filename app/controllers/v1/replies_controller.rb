module V1
  class RepliesController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :target, except: [:destroy]
    before_action :body_valid?, only: [:create]

    def create
      silenced_check! @current_user
      illegal_keyword_check! :body
      comment? ? create_comment_replies : create_reply_replies
      @current_user.dynamics.create(option_type: 'reply', target: @reply)
      # 生成积分
      Services::Integrals::RecordService.call(@current_user, 'comment', target: @reply)
    end

    def destroy
      Reply.find(params[:id]).destroy!
      render_api_success
    end
    
    private

    def create_comment_replies
      @reply = Reply.create!(user_id: @current_user.id,
                             body: params[:body],
                             comment_id: @target.id,
                             target: @target.target,
                             reply_user_id: @target.user.id)
    end

    def create_reply_replies
      @reply = Reply.create!(user_id: @current_user.id,
                             body: params[:body],
                             comment_id: @target.comment.id,
                             target: @target.target,
                             reply_id: @target.id,
                             reply_user_id: @target.user.id)
    end

    def target
      requires! :target_id
      requires! :target_type, values: %w[comment reply]
      @target = comment? ? Comment.find(params[:target_id]) : Reply.find(params[:target_id])
    end

    def body_valid?
      requires! :body
    end

    def comment?
      params[:target_type].eql? 'comment'
    end
  end
end
