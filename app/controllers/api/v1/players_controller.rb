class Api::V1::PlayersController < ApplicationController

  # def index
  #   conn = JSON.parse Faraday.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').body
  #   sleep 2
  #   deck_id = conn["deck_id"] #bad
  #   card = JSON.parse Faraday.get("https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=1").body
  #   sleep 2
  #   STDERR.puts card
  #   render json:  card
  # end

  def create
    @player = Player.find_or_create_by(username: params["username"])
    if @player.money.nil?
      @player.money = 100
    end
    @player.save
      render json: {logged_in: !!@player, player_id: @player.id}
  end



  def show

    @player = Player.find(params[:id])
    money = @player.money
    render json: {money: money}
  end

  # def update
  #   @player = Player.find_by(username: params["username"])
  #   @player.money =
  # end

  # def login
  #   render json: {login: "hello"}
  # end


end
