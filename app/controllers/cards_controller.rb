class CardsController < ApplicationController
  require 'open-uri'

  def search
    @res = nil
  end

  def find
    if params[:commit].include?("random")
      request_get_and_save "/random"
      render 'search'
    else
      if params[:cards][:card_name].blank?
        # tymczasowo
        if params[:cards][:red] == '1' && params[:cards][:cmc2] == '1'
          request_get_and_save '/search?order=cmc&q=c%3Ared+pow%3D3'
          render 'search'
        else
        # tymczasowo
          flash.now[:danger] = "No card name entered."
          render 'search'
        end
      else
        begin
          request_get_and_save "/named?fuzzy=#{params[:cards][:card_name]}"
          render 'search'
        rescue OpenURI::HTTPError => e
          flash.now[:danger] = "Card not found." if e.message == "404 Not Found"
          render 'search'
        end
      end
    end
  end

  def collection

  end

  def add
    if params[:cards][:count]
      # errors.add "Number of cards was not specified."
      flash.now[:danger] = "Number of cards was not specified."
      request_get_and_save "/named?exact=#{params[:title]}"
      render 'search'
    else
      begin
        collected_card = Card.find_by(title: params[:title])
        current_user.add_card collected_card
        current_user.collected_cards.where(card_id: collected_card.id).update(count: params[:cards][:count])
        flash.now[:success] = "#{params["title"]} successfully added to your collection! Number of copies: #{params[:cards][:count]}"
        render 'search'
      rescue Exception => e
        flash.now[:danger] = e.message
        render 'search'
      end
    end
  end

  private

    def permitted_params
      params.permit(:user_id, :card_id, :title, :cards["count"])
    end

    def request_get_and_save url_extra=''
      url_base = "https://api.scryfall.com/cards"
      url = url_base + url_extra
      buffer = open(url).read
      # Rails::logger.debug "%"*80
      # Rails::logger.debug CGI.escape("power=3")
      # Rails::logger.debug "%"*80
      @result = JSON.parse(buffer)
      















      # @results = User.where(activated: true).paginate(page: params[:page])
      # card = Card.new(title: @result["name"], image_url: @result["image_uris"]["normal"])
      # card.save
    end

end
