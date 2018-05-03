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
    conn = Faraday.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1')
    # response = conn.get("/new/shuffle/?deck_count=1")
    STDERR.puts conn.body
    render json:  conn.body
    # render "HELLO"
    # ren
  end


end
