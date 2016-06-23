class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def dashboard
    @user = User.find params[:id]
    @timeline = @user.prepare_timeline
  end
end
