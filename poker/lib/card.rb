class Card
  attr_reader :suit, :val
  
  def initialize(suit, val)
    @suit, @val = suit, val
  end
  
  def suits
    { spades: "S",
      clubs: "C",
      hearts: "H",
      diamonds: "D" }
  end
  
  def vals
    { 1 => "A", 
      2 => "2",
      3 => "3",
      4 => "4",
      5 => "5",
      6 => "6",
      7 => "7",
      8 => "8",
      9 => "9",
     10 => "10",
     11 => "J",
     12 => "Q",
     13 => "K",
     14 => "A"}
  end
  
  def display
    vals[val] + suits[suit]
  end
end