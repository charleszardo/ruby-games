require_relative 'hand'

class Player
  def initialize
    @hand = Hand.new
    @coins = 0
  end
  
  def receive_card(card)
    @hand.add_card(card)
  end
  
  def receive_coins(num)
    @coins += num
  end
  
  def perform_action
    action = {
      "B" => :bet,
      "F" => :fold,
      "S" => :see,
      "R" => :raise
    }
    
    puts "bet (B), fold (F), see current bet (S), raise (R)"
    action = gets.chomp.upcase
  end
end