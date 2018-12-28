class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'sessions/new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to home_path
  end

  private

    def logout
      forget current_user
      session.delete(:user_id)
      @current_user = nil
    end

end
