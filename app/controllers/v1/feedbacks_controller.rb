module V1
  class FeedbacksController < ApplicationController
    include UserAuthorize
    before_action :current_user

    def create
      requires! :contact
      requires! :content
      Feedback.create(contact: params[:contact],
                      content: params[:content],
                      user_id: @current_user&.id)
      render_api_success
    end
  end
end
