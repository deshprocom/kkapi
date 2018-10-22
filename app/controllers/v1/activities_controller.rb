module V1
  class ActivitiesController < ApplicationController
    # 获取活动列表
    def index
      @activities = Activity.published.order(begin_time: :desc).page(params[:page]).per(params[:page_size])
    end

    def show
      @activity = Activity.find(params[:id])
      @activity.increase_page_views
    end
  end
end
