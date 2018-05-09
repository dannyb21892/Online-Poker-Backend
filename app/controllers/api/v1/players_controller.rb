class Api::V1::PlayersController < ApplicationController

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


end
