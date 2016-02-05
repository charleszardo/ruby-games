require_relative 'player'
require_relative 'deck'

class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @deck = Deck.new
    @active_players = [@player1, @player2]
    @init_coins = 20
    @bet = 1
  end
  
  def play
    setup
    round
  end
  
  def setup
    distribute_coins
    deal_hands
  end
  
  def distribute_coins
    @active_players.each { |player| player.receive_coins(@init_coins) }
  end
  
  def round
    @active_players.each do |player|
      player.peform_action
    end
  end
  
  def deal_hands
    5.times do
      @active_players.each do |player|
        card = @deck.deal
        player.receive_card(card)
      end
    end
  end
end