class CardsController < ApplicationController
  require 'open-uri' # może się przydać
  before_action :setupBasicVariables, only: [:search, :find]

  def search
  end

  def find
    # temp
    # jeśli jest random, szukaj randoma, jeśli nie, czegoś konkretnego
    if params[:commit].include?("random")
      request_get_and_save "/random"
    # temp end
    else
      begin
        append = params[:cards][:match_name_exactly] == "1" ? "/named?exact=" : "/search?q="
        append += params[:cards][:card_name] if params[:cards][:card_name].present?
        append += "+unique%3Aprints" if params[:cards][:all_prints] == "1"
        append += add_types_to_search
        append += add_colors_to_search
        append += add_cmc_to_search
        append += add_power_to_search
        append += add_toughness_to_search
        request_get_and_save append
      rescue OpenURI::HTTPError => e
        flash.now[:danger] = "Card not found." if e.message == "404 Not Found"
      end
    end
    render 'search'
  end

  private

  def setupBasicVariables
    @colors = ["white", "blue", "black", "red", "green", "colorless"]
    @types = ["basic", "clue","cartouche", "curse", "saga", "treasure", "vehicle", "legendary", "token", "artifact", "conspiracy", "creature", "emblem", "equipment", "aura", "instant", "sorcery", "enchantment", "plane", "planeswalker", "scheme", "tribal", "land", "world"].sort
    @colors_images = {}
    @colors.each do |color|
      @colors_images[color] = "http://gatherer.wizards.com/images/Redesign/#{color.capitalize}_Mana.png"
    end
  end

    def add_types_to_search
      return "" if params[:cards][:card_type].count == 1
      types_to_search = []
      params[:cards][:card_type][1..-1].each do |type|
        types_to_search << CGI::escape("type:" + type.downcase)
      end
      if types_to_search.count == 1
        return "+#{types_to_search[0]}"
      else
        types_to_search = types_to_search.join("+OR+")
        return "+" + CGI::escape("(") +types_to_search + CGI::escape(")")
      end
    end

    def add_colors_to_search
      return "" if params[:cards][:color].count == 1
      colors_to_search = ""
      params[:cards][:color][1..-1].each do |color|
        if color == "Blue"
          colors_to_search += "U"
        else
          colors_to_search += color.capitalize[0]
        end
      end
      if params["cards"]["match_colors_roughly"] == "1"
        return "+" + CGI::escape("color<=#{colors_to_search}")
      else
        return "+" + CGI::escape("color=#{colors_to_search}")
      end
    end

    def add_cmc_to_search
      return "" if params[:cards][:cmc].count == 1
      cmc_to_search = Array.new
      params[:cards][:cmc][1..-1].each do |cmc|
        if(cmc=="10+")
          cmc_to_search << CGI::escape("cmc>10")
        else
          cmc_to_search << CGI::escape("cmc=" + cmc)
        end
      end
      if cmc_to_search.count == 1
        return "+#{cmc_to_search[0]}"
      else
        cmc_to_search = cmc_to_search.join("+OR+")
        return "+" + CGI::escape("(") + cmc_to_search + CGI::escape(")")
      end
    end

    def add_power_to_search
      return "" if params[:cards][:power].count == 1
      power_to_search = []
      params[:cards][:power][1..-1].each do |power|
        if(power=="10+")
          power_to_search << CGI::escape("power>10")
        else
          power_to_search << CGI::escape("power=" + power)
        end
      end
      if power_to_search.count == 1
        return "+#{power_to_search[0]}"
      else
        power_to_search = power_to_search.join("+OR+")
        return "+" + CGI::escape("(") + power_to_search + CGI::escape(")")
      end
    end

    def add_toughness_to_search
      if params[:cards][:toughness].count == 1
        return ""
      else
        toughness_to_search = Array.new
        params[:cards][:toughness][1..-1].each do |toughness|
          if(toughness=="10+")
            toughness_to_search << CGI::escape("toughness>10")
          else
            toughness_to_search << CGI::escape("toughness=" + toughness)
          end
        end
        if toughness_to_search.count == 1
          return "+#{toughness_to_search[0]}"
        else
          toughness_to_search = toughness_to_search.join("+OR+")
          return "+" + CGI::escape("(") + toughness_to_search + CGI::escape(")")
        end
      end
    end

    def permitted_params
      params.permit(:user_id, :card_id, :name, :cards["count"])
    end

    def request_get_and_save url_extra=''
      url_base = "https://api.scryfall.com/cards"
      url = url_base + url_extra
      Rails::logger.debug url
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
          save_one_face face, card["id"]
        end
      else
        save_one_face card
      end
    end

    def save_one_face card, id=""
      # raise
      card = Card.new(
        name: card["name"],
        image_url_normal: card["image_uris"]["normal"],
        image_url_small: card["image_uris"]["small"],
        mana_cost: save_mana_cost(card["mana_cost"]),
        cmc: card["cmc"],
        type_line: card["type_line"],
        oracle_text: save_oracle_text(card),
        power: card["power"],
        toughness: card["toughness"],
        card_id: save_card_id(card, id)
      )
      card.save
    end

    def save_card_id(card, id)
      if card["id"].present?
        return card["id"]
      else
        return id+card["name"]
      end
    end

    def save_oracle_text card
      # raise
      if card["layout"] == "split"
        oracle_text = ""
        card["card_faces"].each do |face|
          oracle_text << (face["name"] + ": " + face["oracle_text"] + "\n")
        end
        return oracle_text
      else
        return card["oracle_text"]
      end
    end

end
