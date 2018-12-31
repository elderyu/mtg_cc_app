class CardsController < ApplicationController
  require 'open-uri'

  def search
    @res = nil
  end

  def find
    # temp
    if params[:commit].include?("random")
      request_get_and_save "/random"
    # temp end
    else
      if params[:cards][:card_name].blank?
        # temp
        if params[:cards][:red] == '1' && params[:cards][:cmc2] == '1'
          request_get_and_save '/search?order=cmc&q=c%3Ared+pow%3D3'
        else
        # temp end
          flash.now[:danger] = "No card name entered."
        end
      else
        begin
          request_get_and_save "/named?fuzzy=#{params[:cards][:card_name]}"
        rescue OpenURI::HTTPError => e
          flash.now[:danger] = "Card not found." if e.message == "404 Not Found"
        end
      end
    end
    render 'search'
  end

  def collection
    @result = current_user.cards
  end

  def add
    if params[:cards][:count].nil?
      flash.now[:danger] = "Number of cards was not specified."
      request_get_and_save "/named?exact=#{params[:name]}"
    else
      add_to_collection params[:name]
    end
    render 'search'
  end

  private

    def add_to_collection card_name
      if params["layout"] == "transform"
        faces_names = params["name"].split(" // ")
        faces_names.each do |face_name|
          add_face_to_collection face_name
        end
      else
        add_face_to_collection card_name
      end
    end

    def add_face_to_collection face_name
      collected_card = Card.find_by(name: face_name)
      current_user.add_card collected_card
      current_user.collected_cards.where(card_id: collected_card.id).update(count: params[:cards][:count])
      flash.now[:success] = "#{params[:name]} successfully added to your collection! Number of copies: #{params[:cards][:count]}"
    end

    def permitted_params
      params.permit(:user_id, :card_id, :name, :cards["count"])
    end

    def request_get_and_save url_extra=''
      url_base = "https://api.scryfall.com/cards"
      url = url_base + url_extra
      buffer = open(url).read
      result = JSON.parse(buffer)
      if result.present?
        @result = result
        if result["data"].present?
          result = result["data"]
          save_multiple_cards result
        else
          save_one_card result
        end
        flash.now[:danger] = result
      end
    end

    # zapisywanie kart do bazy

    def save_multiple_cards result
      result.each do |card|
        save_one_card card
      end
    end

    def save_one_card card
      if card["layout"] == "transform"
        card["card_faces"].each do |face|
          save_one_face face
        end
      else
        save_one_face card
      end
    end

    def save_one_face card
      card = Card.new(
        name: card["name"],
        image_url_normal: card["image_uris"]["normal"],
        image_url_small: card["image_uris"]["small"],
        mana_cost: card["mana_cost"],
        cmc: card["cmc"],
        type_line: card["type_line"],
        oracle_text: oracle_text(card),
        power: card["power"],
        toughness: card["toughness"],
      )
      card.save
    end

    def oracle_text card
      if card["layout"] == "split"
        oracle_text = ""
        card["card_faces"].each do |face|
          Rails::logger.debug "card_face_flower"
          oracle_text << (face["name"] + ": " + face["oracle_text"] + "\n")
        end
        oracle_text
      else
        card["oracle_text"]
      end
    end

end
