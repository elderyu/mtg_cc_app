class UserController < ApplicationController

  def new
    @user = User.new(params[:id])
  end
end
