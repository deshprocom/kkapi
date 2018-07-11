module V1
  class WalletsController < ApplicationController
    include UserAuthorize
    before_action :login_required

    def account; end

    def account_details
      @details = @current_user.pocket_moneys.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end
  end
end
