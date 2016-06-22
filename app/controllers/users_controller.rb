class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def dashboard
    @user = User.find params[:id]
    @user_events = Ahoy::Event.where(user_id: @user).reverse_order
  end
end
