module V1
  module Account
    class IntegralController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def tasks
        @result = Services::Integrals::TaskList.call(@current_user).group_by { |t| t[:finished] }
        @result
      end

      def details
        @result = Integral.active.order(created_at: :desc).page(params[:page]).per(params[:page_size])
      end

      def award
        requires! :option_type
        tasks = @current_user.integrals.where(option_type: params[:option_type]).not_active.today
        total_points = tasks.sum(:points)

        tasks.each(&:touch_active!)
        @current_user.increase_points(total_points)
        render_api_success
      end
    end
  end
end
