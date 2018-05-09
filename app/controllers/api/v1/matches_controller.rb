
class Api::V1::MatchesController < ApplicationController
  @@matchsize = 2

  def index
    @matches = Match.all.select{|match| match.players.length < @@matchsize} #use all games and add spectate mode to games in progress
    @owners = @matches.map{|match| Player.find(match.owner_id).username} #or use only games that users can join
    @merged = {data: []}
    @matches.each_with_index{|m, i| @merged[:data].push({match: m, owner: @owners[i], openSlots: @@matchsize-m.players.length})}
    render json: @merged
  end

  def create
    @owner = Player.find_by(username: params["owner"])
    @match = Match.create(owner_id: @owner.id, active: false, judged: false)
    PlayerSlot.create(match_id: @match.id, player_id: @owner.id)
    render json: {
      newOpenGame: {
        owner: params["owner"],
        match: @match,
        openSlots: @@matchsize-@match.players.length
      },
      players: @match.players.map{|player| player.username}

    }
  end

  def show
    @match = Match.find(params[:id])
    output = []
    @match.kards.each do |card|
      output.push({player: Player.find(card.player_id).username, card: card})
    end
    if @match.judged
      results = self.judge_game(@match)[:judgement]
    else
      results = false
    end
    render json: {
      data: output,
      active: @match.active,
      judged: @match.judged,
      judgement: results
    }
  end

  def update

    if params["app_action"] == "join_game"
      player = Player.find_by(username: params["data"]["username"])
      if !Match.find(params[:id]).players.include?(player)
        newSlot = PlayerSlot.new(match_id: params[:id], player_id: player.id)
      end
      if newSlot
        newSlot.save
      end
      render json: {
        response: true, money: player.money
      }

    elsif params["app_action"] == "start_game"
      deck = JSON.parse Faraday.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').body
      deck_id = deck["deck_id"]
      #add Mr roboto as a player
      mrroboto = Player.find_or_create_by(username: "Mr Roboto")
      newSlot = PlayerSlot.create(match_id: params[:id], player_id: mrroboto.id)

      match = Match.find(params[:id])
      match.players.each do |player|
        cards = JSON.parse Faraday.get("https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=5").body
        if cards["success"]
          cards["cards"].each do |card|
            Kard.create(match_id: params[:id], player_id: player.id, img_link: card["image"], value: card["value"], suit: card["suit"], code: card["code"] )
          end
        end
      end
      match.active = true
      match.save
      render json: {
        response: match.active
      }
    elsif params["app_action"] == "judge_game"
      match = Match.find(params[:id])
      output = self.judge_game(match)
      render json: output
    end

  end

  def judge_game(match)
    cards = {}
    match.players.each do |player|
      cards["#{player.username}"] = match.kards.select{|card| card.player_id == player.id}
    end

    hands = {}

    cards.each do |key, val|
      hands[key] = PokerHand.new(val.map{|card| (card[:code][0] == "0" ? ("T" + card[:code][1]) : card[:code])})
    end

    winner = {}
    ranks = {}

    hands.each do |key, val|
      winner[key] = true
      ranks[key] = hands[key].rank
      hands.each do |k, v|
        compare = hands[key] >= hands[k]
        winner[key] = winner[key] && compare
      end
    end

    match.judged = true
    match.active = false
    match.save

    #############mr roboto cards
    mrroboto = Player.find_by(username: "Mr Roboto")
    rcards = match.kards.select { |card| card.player_id == mrroboto.id}
    rcardimages = rcards.collect {|card| card.img_link}
    ################### update money here
    player = match.players.select {|player| player.username !="Mr Roboto"}
    if winner["Mr Roboto"]
      player[0].money = player[0].money-10
    else
      player[0].money = player[0].money+10
    end
    player[0].save
    puts player[0].money

    return {
      judgement: {
        hands: hands,
        ranks: ranks,
        winner: winner,
        mrrobotoimages: rcardimages,
        money: player[0].money
      },
      judged: match.judged,
      active: match.active
    }
  end

end
