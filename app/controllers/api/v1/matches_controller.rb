class Api::V1::MatchesController < ApplicationController
  def index
    @matches = Match.all
    render json: @matches
  end

  def create
    @owner = Player.find_by(username: params["owner"])
    @match = Match.create
    PlayerSlot.create(match_id: @match.id, player_id: @owner.id)
    render json: {owner: params["owner"], players: @match.players.map{|player| player.username}, openSlots: (5-@match.players.length)}
  end

end
