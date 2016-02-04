require_relative 'hand'

class Player
  def initialize
    @hand = Hand.new
  end
  
  def receive_card(card)
    @hand.add_card(card)
    @hand.reveal
  end
end