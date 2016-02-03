class Card
  attr_reader :val, :suit
  
  def initialize(suit, val)
    @suit, @val = suit, val
  end
end