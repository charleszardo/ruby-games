class Hand
  def initialize
    @cards = []
    @hand_types = [:royal_flush,
                   :straight_flush,
                   :four_of_a_kind,
                   :full_house,
                   :flush,
                   :straight,
                   :three_of_a_kind,
                   :two_pair,
                   :one_pair,
                   :high_card]
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
  
  def determine_hand
    hand = nil
    @hand_types.each_with_index do |type, idx|
      meth = type.to_s + "?"
      result = self.send(meth)
      if result
        hand = {hand: type,
                idx: idx,
                card: result}
        break
      end
    end
  end
end