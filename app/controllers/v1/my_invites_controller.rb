module V1
  class MyInvitesController < ApplicationController
    include UserAuthorize
    before_action :login_required

    # 1级和2级用户均可查看此接口
    def index
      raise_error 'access_denied' if @current_user.r_level >= 3
      s_users = @current_user.user_relation.s_users
      @count = s_users.count
      @invite_users = s_users.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    # 只有1级用户才有间接用户列表
    def indirect
      raise_error 'access_denied' unless @current_user.r_level.eql?(1)
      requires! :target_id
      @target = User.find_by!(user_uuid: params[:target_id])
      # 判断这个用户是否是当前用户推荐的
      raise_error 'access_denied' unless @target.user_relation.p_user&.user.eql?(@current_user)
      s_users = @target.user_relation.s_users
      @count = s_users.count
      @invite_users = s_users.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    # 查看是否显示 邀请用户的菜单
    def display_check; end

    # 获取邀请奖励明细
    def award_details
      @pocket_moneys = @current_user.pocket_moneys.invite_list.page(params[:page]).per(params[:page_size])
    end

    # 邀请统计
    def count; end
  end
end
