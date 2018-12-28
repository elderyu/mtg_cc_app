class Card < ApplicationRecord
  validates :title, presence: true, uniqueness: {case_sensitive: false}

  has_many :collected_cards, class_name: "CollectedCards", dependent: :destroy, foreign_key: :id
  has_many :users, through: :collected_cards
end
