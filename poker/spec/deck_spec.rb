require 'rspec'
require 'deck'

describe Deck do
  describe "#initialize" do
    subject(:deck) { Deck.new }
    it "initializes with 52 cards" do
      expect(deck.deck.size).to eq(52)
    end
  end
end