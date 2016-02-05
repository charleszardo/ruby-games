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
end