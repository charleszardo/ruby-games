require_relative 'card'
require_relative 'board'
require_relative 'player'
require_relative 'game'

if $PROGRAM_NAME == 'arcade.rb'
  h = Human.new
  c = Computer.new
  g = Game.new(h)
  g.play
end
