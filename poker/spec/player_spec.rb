require 'rspec'
require 'player'

describe Player do
  subject(:player) { Player.new }
  describe "#valid_action?" do
    it "determines a valid action" do
      expect(player.valid_action?("xyz")).to eq(false)
      expect(player.valid_action?("F")).to eq(true)
    end
    
  end
end