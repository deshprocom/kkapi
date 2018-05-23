module V1
  class ReportsController < ApplicationController
    include UserAuthorize
    before_action :login_required
    before_action :target

    def create
      requires! :body
      @current_user.reports.create(target: @target, body: params[:body])
      render_api_success
    end

    private

    def target
      requires! :target_id
      requires! :target_type, values: %w[topic]
      @target = params[:target_type].classify.safe_constantize.find(params[:target_id])
    end
  end
end
