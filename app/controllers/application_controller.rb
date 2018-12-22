class ApplicationController < ActionController::Base

  # bo potrzebny w sessions controller i users controler
  def logged_in?
    !session[:user_id].nil?
  end

end
