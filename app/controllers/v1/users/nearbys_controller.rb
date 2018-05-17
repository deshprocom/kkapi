module V1
  module Users
    class NearbysController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        @nearby_users = @current_user.nearbys(5000).limit(30)
      end

      def create
        @current_user.update!(lat: params[:lat], lng: params[:lng])
        render_api_success
      end
    end
  end
end
