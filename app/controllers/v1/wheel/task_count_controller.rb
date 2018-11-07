module V1
  module Wheel
    class TaskCountController < ApplicationController
      include UserAuthorize
      before_action :login_required

      def index
        @wheel_task_count = @current_user.wheel_task_counts&.find_by(date: Date.current)
      end
    end
  end
end
