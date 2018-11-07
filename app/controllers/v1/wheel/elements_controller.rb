module V1
  module Wheel
    class ElementsController < ApplicationController
      include UserAuthorize
      before_action :login_required
      
      def index
        @elements = WheelElement.position_desc.limit(10)
      end
    end
  end
end
