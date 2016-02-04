class Hand
  def initialize
    @cards = []
  end
  
  def add_card(card)
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