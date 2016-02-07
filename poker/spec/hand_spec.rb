require 'rspec'
require 'hand'

describe Hand do
  subject(:hand1) { Hand.new }
  subject(:hand2) { Hand.new }
  subject(:hand3) { Hand.new }
  let(:card1) { double('card', :suit => :spades, :val => 10) }
  let(:card2) { double('card', :suit => :spades, :val => 11) }
  let(:card3) { double('card', :suit => :spades, :val => 12) }
  let(:card4) { double('card', :suit => :spades, :val => 13) }
  let(:card5) { double('card', :suit => :spades, :val => 14) }
  let(:card6) { double('card', :suit => :diamonds, :val => 14) }
  let(:card7) { double('card', :suit => :diamonds, :val => 5) }
  
  describe "size" do
    it "should never exceed five cards" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      expect { hand1.add_card(card6) }.to raise_error
    end
  end
  
  describe "#same_suit?" do
    it "correctly determines if cards are same suit" do
      cards = [card1, card2, card3, card4, card5, card6]
      cards[0..4].each { |card| hand1.add_card(card)}
      cards[1..5].each { |card| hand2.add_card(card)}
      expect(hand1.same_suit?).to be true
      expect(hand2.same_suit?).to be false
    end
  end
  
  describe "#royal_count" do
    it "correctly counts number of royalty" do
      cards = [card1, card2, card3, card4, card7]
      cards[0..4].each { |card| hand1.add_card(card)}
      expect(hand1.royal_count).to eq(4)
    end
  end
  
  describe "#royal_flush?" do
    it "correctly determines a royal flush" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card4, card6]
      cards.each { |card| hand2.add_card(card) }
      cards = [card1, card2, card3, card4, card7]
      cards.each { |card| hand3.add_card(card) }
      
      expect(hand1.royal_flush?).to be true
      expect(hand2.royal_flush?).to be false
      expect(hand3.royal_flush?).to be false
    end
  end
end