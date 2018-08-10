module V1
  class HotlinesController < ApplicationController
    def index
      optional! :line_type, values: Hotline.line_types.keys
      @hotlines = Hotline.where(line_type: params[:line_type])
                    .order(position: :desc).page(params[:page]).per(params[:page_size])
    end
  end
end
