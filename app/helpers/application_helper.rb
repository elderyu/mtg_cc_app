module ApplicationHelper

  def full_title title=''
    title.blank? ? "MTG CC App" : title + " | MTG CC App"
  end

  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find(user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget user
    session.delete(:user_id)
    # session[:user_id] = nil
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def save_mana_cost mana_cost
    if mana_cost.present?
      # raise
      mana_cost = mana_cost.tr('{}',' ')
    end
    mana_cost
  end

end
