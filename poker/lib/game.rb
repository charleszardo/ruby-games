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
    @pot = 0
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
    @players_in_round = @active_players
    @current_bet = @bet
    @pot = 0
    2.times { betting_round }
    determine_round_winner
    payout(player)
  end
  
  def betting_round
    @players_in_round.each do |player|
      player.display_hand
      action = handle_action(player, player.perform_action(@current_bet))
      unless action == :fold
        discards = player.discard
        (5 - discards.size).times do
          deal_card(player)
        end
      end
    end
  end
  
  def determine_round_winner
    
  end
  
  def payout(player)
    
  end
  
  def handle_action(player, action)
    case action
    when :fold
      @players_in_round.delete(player)
    when :see
      @pot += player.pay(@current_bet)
    when :raise
      @current_bet = raise(player)
      @pot += @current_bet
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
  
  def deal_card(player)
    card = @deck.deal
    player.receive_card(card)
  end
end