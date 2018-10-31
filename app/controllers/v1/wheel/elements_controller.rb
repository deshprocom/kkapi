module V1
  module Wheel
    class ElementsController < ApplicationController
      def index
        @elements = WheelElement.position_desc.limit(10)
      end
    end
  end
end
