class Card
  attr_reader :suit, :val
  
  def initialize(suit, val)
    @suit, @val = suit, val
  end
end