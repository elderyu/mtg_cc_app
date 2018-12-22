class SessionsController < ApplicationController
  include SessionsHelper

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'sessions/new'
    end
  end

  def destroy
    logout
    redirect_to home_path
  end
end
