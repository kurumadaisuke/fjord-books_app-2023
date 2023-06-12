class UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page]).per(2)
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
end
