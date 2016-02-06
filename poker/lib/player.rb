require_relative 'hand'

class Player
  def initialize
    @hand = Hand.new
    @coins = 0
    @actions = {
      "B" => :bet,
      "F" => :fold,
      "S" => :see,
      "R" => :raise
    }
  end
  
  def receive_card(card)
    @hand.add_card(card)
  end
  
  def receive_coins(num)
    @coins += num
  end
  
  def perform_action
    puts "bet (B), fold (F), see current bet (S), raise (R)"
    action = gets.chomp.upcase
    raise "invalid action" if !valid_action?(action)
  rescue
    retry
  end
  
  def valid_action?(action)
    @actions.keys.include?(action)
  end
end