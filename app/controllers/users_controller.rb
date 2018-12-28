class UsersController < ApplicationController
before_action :require_logged_in, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'users/new'
    end
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def require_logged_in
      redirect_to root_path unless logged_in?
    end

end
