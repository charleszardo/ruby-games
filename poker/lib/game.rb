require_relative 'player'
require_relative 'deck'

class Game
  attr_reader :init_coins, :active_players
  
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @deck = Deck.new
    @active_players = [@player1, @player2]
    @players_in_round = [@player1, @player2]
    @init_coins = 20
    @bet = 1
  end
  
  def play
    setup
    round
  end
  
  def setup
    distribute_coins
    deal_cards
  end
  
  def distribute_coins
    @active_players.each { |player| player.receive_coins(@init_coins) }
  end
  
  def round
    @players_in_round = @active_players.dup
    @active_players.each do |player|
      discards = player.discard
      deal_cards(player, discards.size)
      handle_action(player, player.peform_action)
    end
  end
  
  def handle_action(player, action)
    case action
    when :bet
    when :fold
    when :see
    when :raise
  end
  
  def deal_cards(players=@active_players, num=5)
    num.times do
     players.each do |player|
        card = @deck.deal
        player.receive_card(card)
      end
    end
  end
end