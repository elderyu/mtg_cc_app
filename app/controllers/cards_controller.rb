class CardsController < ApplicationController

  def search
    @res = nil
  end

  def find
    url = "https://api.scryfall.com/cards/random"
    buffer = open(url).read
    result = JSON.parse(buffer)
    render 'random_card'
    @res = result["name"]
    @res_image = result["image_uris"]["normal"]
    render 'search'
  end

end
