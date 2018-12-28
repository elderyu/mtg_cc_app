class CollectionController < ApplicationController

  def add
    begin
      collected_card = Card.new(permitted_params)
      Rails::logger.debug collected_card
      current_user.add_card collected_card
      render 'cards/search'
    rescue Exception => e
      flash.now[:danger] = e.message
      render 'cards/search'
    end
  end

  private

  def permitted_params
    params.permit(:user_id, :card_id, :title, :collection["count"])
  end

end
