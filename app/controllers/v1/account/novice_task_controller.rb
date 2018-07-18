module V1
  module Account
    class NoviceTaskController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        # 判断是否是新用户 新用户才有权限访问
        raise_error 'access_denied' unless @current_user.new_user
      end
    end
  end
end
