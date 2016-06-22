class HomeController < ApplicationController
  def index
    @current_visit = current_visit
  end

  def visits
    @current_user = current_user
    @current_visit = current_visit
    @user_visits = current_user.visits
  end
end
