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
    @players_in_round.each do |player|
      next if @players_in_round.count <= 1
      action = betting_round(player)
      discard_round(player, action)
    end
    @players_in_round.each do |player|
      next if @players_in_round.count <= 1
      action = betting_round(player)
    end
    
    winner = determine_round_winner
    payout(winner)
  end
  
  def discard_round(player, prev_action)
    unless prev_action == :fold
      num_discards = player.discard
      
      deal_cards([player], num_discards)
    end
  end
  
  def betting_round(player)
    player.display_hand
    action = player.perform_action(@current_bet)
    return handle_action(player, action)
  end
  
  def determine_round_winner
    if @players_in_round.count == 1
      return @players_in_round.first
    else
      
    end
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
    action
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