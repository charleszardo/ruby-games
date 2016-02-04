require 'rspec'
require 'deck'

describe Deck do
  describe "#initialize" do
    subject(:deck1) { Deck.new }
    subject(:deck2) { Deck.new }
    subject(:deck3) { Deck.new }
    subject(:deck4) { Deck.new }
    subject(:deck5) { Deck.new }
    
    it "initializes with 52 unique cards" do
      deck_hash = {}
      deck1.deck.each do |card|
        k = [card.suit, card.val]
        deck_hash[k] = deck_hash[k] || true
      end
      
      expect(deck1.deck.size).to eq(52)
      expect(deck_hash.keys.size).to eq(52)
    end
    
    it "shuffles deck" do
      decks = [deck1, deck2, deck3, deck4, deck5]
      first_cards = decks.map do |deck|
        first_card = deck.deck.first
        first_card = [first_card.suit, first_card.val]
        first_card
      end
      
      expect(first_cards.uniq.size).to be > 1
    end
  end
end