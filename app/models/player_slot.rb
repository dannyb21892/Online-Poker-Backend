class PlayerSlot < ApplicationRecord
  validates :match_id, presence: true
  validates :player_id, presence: true
  belongs_to :player
  belongs_to :match
end
