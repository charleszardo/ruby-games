class Hand
  def initialize
    @cards = []
  end
  
  def add_card(card)
    raise "Too many cards" if @cards.size >= 5
    @cards << card
  end
  
  def reveal
    revelation = []
    @cards.each do |card|
      revelation << [card.suit, card.val]
    end
    p revelation
  end
end