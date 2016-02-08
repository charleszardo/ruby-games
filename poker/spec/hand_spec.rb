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
  
  describe "#flush?" do
    it "correctly determines if cards are same suit" do
      cards = [card1, card2, card3, card4, card5, card6]
      cards[0..4].each { |card| hand1.add_card(card)}
      cards[1..5].each { |card| hand2.add_card(card)}
      expect(hand1.flush?).to be true
      expect(hand2.flush?).to be false
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
  
  describe "#straight_flush?" do
    let(:card1) { double('card', :suit => :spades, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 3) }
    let(:card3) { double('card', :suit => :spades, :val => 4) }
    let(:card4) { double('card', :suit => :spades, :val => 5) }
    let(:card5) { double('card', :suit => :spades, :val => 6) }
    let(:card6) { double('card', :suit => :hearts, :val => 6) }
    let(:card7) { double('card', :suit => :spades, :val => 7) }
    it "correctly determines a straight flush" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card4, card6]
      cards.each { |card| hand2.add_card(card) }
      cards = [card1, card2, card3, card4, card7]
      cards.each { |card| hand3.add_card(card) }
      
      expect(hand1.straight_flush?).to be true
      expect(hand2.straight_flush?).to be false
      expect(hand3.straight_flush?).to be false
    end
  end
  
  describe "#consecutive?" do
    let(:card1) { double('card', :suit => :spades, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 3) }
    let(:card3) { double('card', :suit => :spades, :val => 4) }
    let(:card4) { double('card', :suit => :spades, :val => 5) }
    let(:card5) { double('card', :suit => :spades, :val => 6) }
    let(:card6) { double('card', :suit => :hearts, :val => 6) }
    let(:card7) { double('card', :suit => :spades, :val => 8) }
    it "correctly determines a consecutive series of cards" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card4, card6]
      cards.each { |card| hand2.add_card(card) }
      cards = [card1, card2, card3, card4, card7]
      cards.each { |card| hand3.add_card(card) }
      
      expect(hand1.consecutive?).to be true
      expect(hand2.consecutive?).to be true
      expect(hand3.consecutive?).to be false
    end
    
    context "with ace" do
      let(:card6) { double('card', :suit => :hearts, :val => 14) }
      let(:card7) { double('card', :suit => :spades, :val => 10) }
      let(:card8) { double('card', :suit => :spades, :val => 11) }
      let(:card9) { double('card', :suit => :spades, :val => 12) }
      let(:card10) { double('card', :suit => :spades, :val => 13) }
      it "correctly determines a consecutive series of cards" do
        cards = [card1, card2, card3, card4, card6]
        cards.each { |card| hand1.add_card(card) }
        cards = [card2, card3, card4, card5, card6]
        cards.each { |card| hand2.add_card(card) }
        cards = [card6, card7, card8, card9, card10]
        cards.each { |card| hand3.add_card(card) }
      
        expect(hand1.consecutive?).to be true
        expect(hand2.consecutive?).to be false
        expect(hand3.consecutive?).to be true
      end
    end
  end
  
  describe "#four_of_a_kind?" do
    let(:card1) { double('card', :suit => :hearts, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 2) }
    let(:card3) { double('card', :suit => :clubs, :val => 2) }
    let(:card4) { double('card', :suit => :diamonds, :val => 2) }
    let(:card5) { double('card', :suit => :spades, :val => 13) }
    let(:card6) { double('card', :suit => :hearts, :val => 4) }
    it "correctly determines a four of a kind" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card5, card6]
      cards.each { |card| hand2.add_card(card) }
      
      expect(hand1.four_of_a_kind?).to be true
      expect(hand2.four_of_a_kind?).to be false
    end
  end
  
  describe "#full_house?" do
    let(:card1) { double('card', :suit => :hearts, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 2) }
    let(:card3) { double('card', :suit => :clubs, :val => 2) }
    let(:card4) { double('card', :suit => :diamonds, :val => 4) }
    let(:card5) { double('card', :suit => :spades, :val => 4) }
    let(:card6) { double('card', :suit => :hearts, :val => 13) }
    it "correctly determines a four of a kind" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card5, card6]
      cards.each { |card| hand2.add_card(card) }
      cards = [card1, card2, card4, card5, card6]
      cards.each { |card| hand3.add_card(card) }
      
      expect(hand1.full_house?).to be true
      expect(hand2.full_house?).to be false
      expect(hand3.full_house?).to be false
    end
  end
  
  describe "#three_of_a_kind?" do
    let(:card1) { double('card', :suit => :hearts, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 2) }
    let(:card3) { double('card', :suit => :clubs, :val => 2) }
    let(:card4) { double('card', :suit => :diamonds, :val => 7) }
    let(:card5) { double('card', :suit => :spades, :val => 13) }
    let(:card6) { double('card', :suit => :hearts, :val => 4) }
    it "correctly determines a three of a kind" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card4, card5, card6]
      cards.each { |card| hand2.add_card(card) }
      
      expect(hand1.three_of_a_kind?).to be true
      expect(hand2.three_of_a_kind?).to be false
    end
  end
  
  describe "#two_pair?" do
    let(:card1) { double('card', :suit => :hearts, :val => 2) }
    let(:card2) { double('card', :suit => :spades, :val => 2) }
    let(:card3) { double('card', :suit => :clubs, :val => 5) }
    let(:card4) { double('card', :suit => :diamonds, :val => 4) }
    let(:card5) { double('card', :suit => :spades, :val => 4) }
    let(:card6) { double('card', :suit => :hearts, :val => 13) }
    it "correctly determines a four of a kind" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand1.add_card(card) }
      cards = [card1, card2, card3, card5, card6]
      cards.each { |card| hand2.add_card(card) }
      
      expect(hand1.two_pair?).to be true
      expect(hand2.full_house?).to be false
    end
  end
end