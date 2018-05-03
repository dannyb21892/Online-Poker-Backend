class PlayersController < ApplicationController

  def index
    # res = Faraday.get 'https://deckofcardsapi.com/api/deck'
    # response = ENV["conn"].get("/new/shuffle/?deck_count=1")
    # response = ENV["conn"]+("/new/shuffle/?deck_count=1")
    # response = ENV["conn"]
    # puts ENV[conn]
    # conn = Faraday.new(:url => 'https://deckofcardsapi.com/api/deck')
    # conn = Faraday.new(:url => 'https://deckofcardsapi.com/api/deck')
    # response = conn.get("/new/shuffle/?deck_count=1")
    conn = JSON.parse Faraday.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').body
    # response = conn.get("/new/shuffle/?deck_count=1")
    sleep 2
    deck_id = conn["deck_id"] #bad

    # deck_id =
    # STDERR.puts `********************#{deck_id}`
    # card = JSON.parse Faraday.get(`https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=1`)
    card = JSON.parse Faraday.get("https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=1").body
    sleep 2
    STDERR.puts card
    # render json:  conn.body
    # render json:  card["cards"][0]["code"]
    render json:  card
    # render "HELLO"
    # ren
  end


end
