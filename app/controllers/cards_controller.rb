class CardsController < ApplicationController
  require 'open-uri'

  def search
    @res = nil
  end

  def find
    url_base = "https://api.scryfall.com/cards"
    url_extra = ''
    if params[:random] == '1'
      url_extra = "/random"
      url = url_base + url_extra
      buffer = open(url).read
      result = JSON.parse(buffer)
      @res_name = result["name"]
      @res_image = result["image_uris"]["normal"]
      card = Card.new(title: result["name"], image_url: result["image_uris"]["normal"])
      render 'search'
    else
      if params[:cards][:card_name].blank?
        flash.now[:danger] = "No card name entered."
        render 'search'
      else
        url_extra = "/named?exact=#{params[:cards][:card_name]}"
        url = url_base + url_extra
        begin
          buffer = open(url).read
          result = JSON.parse(buffer)
          @res_name = result["name"]
          @res_image = result["image_uris"]["normal"]
          card = Card.new(title: result["name"], image_url: result["image_uris"]["normal"])
          card.save
          render 'search'
        rescue OpenURI::HTTPError => e
          flash.now[:danger] = "Card not found" if e.message == "404 Not Found"
          render 'search'
        end
      end
    end
  end

  def collection

  end

  def add
    begin
      collected_card = Card.find_by(title: params[:title])
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
      params.permit(:user_id, :card_id, :title, :cards["count"])
    end

end
