module V1
  class TopicsController < ApplicationController
    include UserAuthorize
    before_action :login_required, except: [:index, :essence, :show]
    before_action :current_user, only: [:show]

    # 获取广场列表
    def index
      @topics = Topic.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    # 获取精华列表
    def essence
      @topics = Topic.excellent.order(created_at: :desc).page(params[:page]).per(params[:page_size])
      render :index
    end

    def show
      @topic = Topic.find(params[:id])
      @topic.increase_page_views
    end

    def create
      requires! :body_type, values: %w[short long]
      send("create_#{params[:body_type]}")
    end

    def destroy
      @current_user.topics.find(params[:id]).destroy
      render_api_success
    end

    def image
      @image = TopicImage.new(image: params[:image])
      if @image.image.blank? || @image.image.path.blank? || @image.image_integrity_error.present?
        raise_error 'file_format_error'
      end
      raise_error 'file_upload_error' unless @image.save
    end

    private

    def create_short
      raise_error 'image_number_exceed' if params[:images]&.count.to_i > 9
      create_params = user_params.dup
      create_params[:cover_link] ||= params[:images]&.first
      @topic = @current_user.topics.create!(create_params)
    end

    def create_long
      requires! :title
      @topic = @current_user.topics.create!(user_params)
    end

    def user_params
      params.permit(:title, :cover_link, :body, :body_type, :lat, :lng, :address_title, :address, images: [])
    end
  end
end
