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
    @current_bet = 1
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
    @current_bet = @bet.dup
  end
  
  def betting_round
    @players_in_round.each do |player|
      handle_action(player, player.peform_action(@current_bet))
      unless action == :fold
        discards = player.discard
        deal_cards(player, discards.size)
      end
    end
  end
  
  def handle_action(player, action)
    case action
    when :fold
      @players_in_round.delete(player)
    when :see
      player.pay(@current_bet)
    when :raise
      @current_bet = raise(player)
    end
  end
  
  def raise(player)
    puts "how much?"
    val = player.request_val.to_i
    raise "invalid value" if val <= @bet || val % @bet != 0
  rescue
    puts "invalid amount, please retry"
    retry
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