class Api::V1::MatchesController < ApplicationController
  def index
    @matches = Match.all.select{|match| match.players.length < 5} #use all games and add spectate mode to games in progress
    @owners = @matches.map{|match| Player.find(match.owner_id).username} #or use only games that users can join
    @merged = {data: []}
    @matches.each_with_index{|m, i| @merged[:data].push({match: m, owner: @owners[i]})}
    render json: @merged
  end

  def create
    @owner = Player.find_by(username: params["owner"])
    @match = Match.create(owner_id: @owner.id)
    PlayerSlot.create(match_id: @match.id, player_id: @owner.id)
    render json: {
      newOpenGame: {
        owner: params["owner"],
        match: @match
      },
      players: @match.players.map{|player| player.username},
      openSlots: (5-@match.players.length)
    }
  end

end
