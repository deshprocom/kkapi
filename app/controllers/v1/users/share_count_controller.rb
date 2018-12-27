module V1
  module Users
    class ShareCountController < ApplicationController
      include UserAuthorize
      before_action :user_self_required
      include Signature
      before_action :signature_required

      def create
        return render_api_success if interval_time_limit?
        # 分享次数 + 1
        @current_user.increase_share_count
        # 奖励积分给用户
        Services::Integrals::RecordService.call(@current_user, 'share')
        # 如果是新用户 做完分享活动可以获取奖励
        @current_user.invite_user_completed_awards
        # 如果分享的活动来自于 活动大转盘分享，那么会给用户增加奖励机会
        WheelTaskCount.award_times_from_share(@current_user) if params[:from].eql?('wheel')
        render_api_success
      end

      def interval_time_limit?
        # 判断用户上一次进来的时间
        time_last_in = Rails.cache.read(share_cache_key).to_i
        time_current_in = Time.current.to_i
        Rails.cache.write(share_cache_key, time_current_in)
        Time.current.to_i - time_last_in < 2
      end

      def share_cache_key
        "kkapi:v1:share_count_in:#{@current_user.user_uuid}"
      end
    end
  end
end
