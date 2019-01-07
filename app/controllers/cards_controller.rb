class CardsController < ApplicationController
  require 'open-uri'

  def search
    # @result = nil
    @colors = ["white", "blue", "black", "red", "green", "colorless"]
    @types = ["creature", "instant", "sorcery", "enchantment", "planeswalker", "other"]
    @colors_images = Hash.new()
    @colors.each do |color|
      @colors_images[color] = "http://gatherer.wizards.com/images/Redesign/#{color.capitalize}_Mana.png"
    end
  end

  def find
    # if params[:total_cards] == "1" || params[:total_cards] == nil
    #   @result = params
    # else
    #   @result = params["data"]
    # end
    # bardzo temporary !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # @result = nil
    @colors = ["white", "blue", "black", "red", "green", "colorless"]
    @types = ["creature", "instant", "enchantment", "planeswalker", "other"]
    @colors_images = Hash.new()
    @colors.each do |color|
      @colors_images[color] = "http://gatherer.wizards.com/images/Redesign/#{color.capitalize}_Mana.png"
    end

    # temp
    # jeśli jest random, szukaj randoma, jeśli nie, czegoś konkretnego
    if params[:commit].include?("random")
      request_get_and_save "/random"
    # temp end
    else
      begin
        # append = "/named?"
        append = params[:cards][:match_name_exactly] == "1" ? "/named?exact=" : "/search?q="
        append += params[:cards][:card_name] if params[:cards][:card_name].present?
        append += add_types_to_search
        append += add_colors_to_search
        Rails::logger.debug append
        request_get_and_save append
      rescue OpenURI::HTTPError => e
        flash.now[:danger] = "Card not found." if e.message == "404 Not Found"
      end
    end
    # raise
    render 'search'
  end

  private

    def add_types_to_search
      if params[:cards][:card_type].count == 1
        return ""
      else
        types_to_search = Array.new
        params[:cards][:card_type].each do |type|
          types_to_search << CGI::escape("type:" + type.downcase)
        end
        if types_to_search.empty?
          return ""
        else
          if types_to_search.count == 1
            types_to_search = "+#{types_to_search[0]}"
          else
            types_to_search = types_to_search.join("+OR+")
            types_to_search = "+" + CGI::escape("(") +types_to_search + CGI::escape(")")
          end
        end
      end
    end

    def add_colors_to_search
      colors_to_search = ""
      # Uwaga: jak nie ma nic do przekazania w tablicy to do parmasów domyślnie dorzucany jest "", żeby tablica była
      params[:cards][:color][1..-1].each do |color|
          if color == "blue"
            colors_to_search += "U"
          else
            colors_to_search += color.capitalize[0]
          end
      end
      unless colors_to_search == ""
        if params["cards"]["match_colors_roughly"] == "1"
          colors_to_search = "+" + CGI::escape("color<=#{colors_to_search}")
        else
          colors_to_search = "+" + CGI::escape("color=#{colors_to_search}")
        end
      end
      colors_to_search
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
        # flash.now[:danger] = result
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
