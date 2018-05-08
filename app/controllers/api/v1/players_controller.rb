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
    @match = Match.find(params["match_id"])
    if @player == @match.players.order(id: :asc)[@match.whoseturn]
      if @player.money >= params["bet"].to_i
        if 0 <= params["bet"].to_i
          @player.money -= params["bet"].to_i
          @player.save

          @match.pot += params["bet"].to_i
          @match.whoseturn = (@match.whoseturn + 1) % (@match.players.length)
          @match.save
          if @match.whoseturn == 0
            @match.judged = true
            @match.save
          end
          render json: {
            success: true,
            whoseturn: @match.whoseturn,
            money: @player.money,
            pot: @match.pot
          }
        else
          render json: {
            success: false,
            error: "You can not bet negative numbers",
            money: @player.money
          }
        end
      else
        render json: {
          success: false,
          error: "You can not bet that much",
          money: @player.money
        }
      end
    else
      render json: {
        success: false,
        error: "It is not yet your turn to bet",
        money: @player.money
      }
    end

  end

  def login
    render json: {login: "hello"}
  end


end
