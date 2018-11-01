module V1
  module Wheel
    class TimesController < ApplicationController
      include UserAuthorize
      before_action :login_required

      def index
        @wheel_time = @current_user.wheel_user_time
      end
    end
  end
end
