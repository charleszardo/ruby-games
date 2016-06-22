require 'set'
require_relative 'player'
require_relative 'computer_player'
require_relative 'game'

if $PROGRAM_NAME == "arcade.rb"
  p1 = GhostPlayer.new("Player 1")
  p2 = GhostPlayer.new("Player 2")
  p3 = GhostComputerPlayer.new("KOMPUTER")
  g = Game.new(p1, p2, p3).play
end
