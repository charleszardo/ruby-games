require 'rspec'
require 'hand'

describe Hand do
  subject(:hand) { Hand.new }
  let(:card1) { double('card', :suit => :spades) }
  let(:card2) { double('card', :suit => :spades) }
  let(:card3) { double('card', :suit => :spades) }
  let(:card4) { double('card', :suit => :spades) }
  let(:card5) { double('card', :suit => :hearts) }
  let(:card6) { double('card', :suit => :diamonds) }
  
  describe "size" do
    it "should never exceed five cards" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand.add_card(card) }
      expect { hand.add_card(card6) }.to raise_error
    end
  end
  
  describe "same_suit?" do
    it "correctly determines if cards are same suit" do
      cards = [card1, card2, card3, card4, card5]
      base_suit = card1.suit
      expect(cards[0..3].all? { |card| card.suit == base_suit }).to be true
    end
  end
end