class HomeController < ApplicationController
  def index
    @current_visit = current_visit
  end
end
