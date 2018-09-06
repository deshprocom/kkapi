module V1
  class TopicsController < ApplicationController
    include UserAuthorize
    before_action :login_required, except: [:index, :essence, :show]
    before_action :current_user, only: [:index, :essence, :show]

    # 获取广场列表
    def index
      @topics = Topic.displayable.order(created_at: :desc).page(params[:page]).per(params[:page_size])
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
      requires! :body
      silenced_check! @current_user
      similarity?(params[:body])
      send("create_#{params[:body_type]}")
      # 生成积分
      Services::Integrals::RecordService.call(@current_user, 'topic', target: @topic)
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
      illegal_keyword_check! :body
      raise_error 'image_number_exceed' if params[:images]&.count.to_i > 9
      create_params = user_params.dup
      create_params[:cover_link] ||= params[:images]&.first
      @topic = @current_user.topics.create!(create_params)
    end

    def create_long
      requires! :title
      illegal_keyword_check! :title, :body
      @topic = @current_user.topics.create!(user_params)
    end

    def user_params
      params.permit(:title, :cover_link, :body, :body_type, :lat, :lng, :address_title, :address, images: [])
    end

    def similarity?(body)
      white = Text::WhiteSimilarity.new
      Topic.last(2).each do |topic|
        raise_error 'similarity_body' if white.similarity(body, topic.body) > 0.95
      end
    end
  end
end
