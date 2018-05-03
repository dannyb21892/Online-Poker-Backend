class Match < ApplicationRecord
  has_many :player_slots
  has_many :players, through: :player_slots
end
