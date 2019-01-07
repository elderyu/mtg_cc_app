class CollectedCardsController < ApplicationController

  def show
    @result = current_user.cards
  end

  def create
    if params["cards"]["count"].nil?
      flash.now[:danger] = "Number of cards was not specified."
      # zmienić na redirect to post with correct name
      request_get_and_save "/named?exact=#{params[:name]}"
    else
      add_to_collection params[:name]
    end
    redirect_to search_path
  end

  def destroy
    CollectedCard.find(params[:id]).delete
    redirect_to collection_path
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
    if found_card = CollectedCard.find_by(user_id: current_user.id, card_id: collected_card.id)
      found_card.update(count: (found_card.count + params["cards"]["count"].to_i))
    else
      current_user.add_card collected_card
      CollectedCard.find_by(user_id: current_user.id, card_id: collected_card.id).update(count: params["cards"]["count"])
    end
    flash[:success] = "#{params[:name]} successfully added to your collection! Total number of copies: #{CollectedCard.find_by(user_id: current_user.id, card_id: collected_card.id).count}"
  end
end
