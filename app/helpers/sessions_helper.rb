module SessionsHelper

  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if logged_in?
      @current_user ||= User.find(session[:user_id])
    end
  end

  def logged_in?
    !session[:user_id].nil?
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

end
