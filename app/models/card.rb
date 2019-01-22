class Card < ApplicationRecord
  validates :name, presence: true
  validates :card_id, presence: true

  has_many :collected_cards, dependent: :destroy
  has_many :users, through: :collected_cards

end
