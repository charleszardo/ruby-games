require 'rspec'
require 'game'

describe Game do
  describe "#setup" do
    subject(:game) { Game.new }
    let(:player) { game.active_players[0] }
    
    it "distributes coins" do
      expect(player).to receive(:receive_coins).with(game.init_coins)
      game.setup
    end
  end
end