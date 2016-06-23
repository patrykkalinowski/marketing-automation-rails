class HomeController < ApplicationController
  def index
    @current_visit = current_visit

    # ahoy.track "Page visit", title: "Home#index"
  end

  def visits
    @current_user = current_user
    @current_visit = current_visit
    @user_visits = current_user.visits
    @user_events = Ahoy::Event.where(user_id: current_user).reverse_order

    current_user.send_welcome_email
  end
end
