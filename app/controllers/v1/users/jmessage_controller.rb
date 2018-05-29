module V1
  module Users
    class JmessageController < ApplicationController
      include UserAuthorize
      before_action :login_required, except: [:index]

      def index
        user = User.find_by!(user_uuid: params[:user_id])
        result = Services::Jmessage::CreateUser.call(user)
        @j_user = result.data[:j_user]
      end

      def create
        result = Services::Jmessage::CreateUser.call(@current_user)
        @j_user = result.data[:j_user]
      end

      def destroy
        j_user = @current_user.j_user
        j_user&.delete_user
        render_api_success
      end
    end
  end
end
