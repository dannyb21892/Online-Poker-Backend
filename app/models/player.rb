class Player < ApplicationRecord
  has_one :player_slot
  has_one :match, through: :player_slot
end
