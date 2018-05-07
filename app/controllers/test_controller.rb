class TestController < ApplicationController
  include UserAuthorize

  def index
    p 'hello'
  end
end
