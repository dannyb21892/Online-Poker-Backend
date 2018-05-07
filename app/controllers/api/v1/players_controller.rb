class Api::V1::PlayersController < ApplicationController

  def index
    conn = JSON.parse Faraday.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').body
    sleep 2
    deck_id = conn["deck_id"]
    card = JSON.parse Faraday.get("https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=1").body
    sleep 2
    STDERR.puts card
    render json:  card
  end

  def create
    @player = Player.find_by(username: params["username"])
    if !@player
      @player = Player.create(username: params["username"], money: 100)
    end
    render json: {
      logged_in: !!@player,
      player_info: {
        id: @player.id,
        money: @player.money
      }
    }
  end

  def update
    @player = Player.find(params[:id])
    if @player.money >= params["bet"].to_i
      @player.money -= params["bet"].to_i
      @player.save
      @match = Match.find(params["match_id"])
      @match.pot += params["bet"].to_i
      @match.save
      render json: {
        success: true,
        money: @player.money,
        pot: @match.pot
      }
    else
      render json: {
        success: false,
        money: @player.money
      }
    end
  end

  def login
    render json: {login: "hello"}
  end


end
