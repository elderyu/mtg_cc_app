class CollectedCard < ApplicationRecord
# attr_accessor :count
  belongs_to :user
  belongs_to :card
end
