require_relative 'card'
require_relative 'hand'

class Deck
  attr_reader :deck
  
  def self.build_deck
    deck = []
    suits = [:spades, :hearts, :diamonds, :clubs]
    vals = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    
    suits.each do |suit|
      vals.each do |val|
        deck << Card.new(suit, val)
      end
    end
    deck.shuffle
  end
  
  def initialize
    @deck = Deck.build_deck
  end
  
  def deal
    deck.pop
  end
end