require 'rspec'
require 'hand'

describe Hand do
  describe "size" do
    subject(:hand) { Hand.new }
    let(:card1) { double('card') }
    let(:card2) { double('card') }
    let(:card3) { double('card') }
    let(:card4) { double('card') }
    let(:card5) { double('card') }
    let(:card6) { double('card') }
    
    it "should never exceed five cards" do
      cards = [card1, card2, card3, card4, card5]
      cards.each { |card| hand.add_card(card) }
      expect { hand.add_card(card6) }.to raise_error
    end
  end
end