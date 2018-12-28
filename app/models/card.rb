class Card < ApplicationRecord
  validates :title, presence: true, uniqueness: {case_sensitive: false}

  has_many :collected_cards, dependent: :destroy
  has_many :users, through: :collected_cards
end
