require 'card'

class Deck
  def self.build_deck
    deck = []
    suits = [:spades, :hearts, :diamonds, :clubs]
    vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    
    suits.each do |suit|
      vals.each do |val|
        deck << Card.new(suit, val)
      end
    end
    deck
  end
  
  def initialize
    @deck = Deck.build_deck
  end
end