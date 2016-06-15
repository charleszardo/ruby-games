require_relative 'code'
require_relative 'player'
require_relative 'game'

if $PROGRAM_NAME == "arcade.rb"
  p2 = Human.new
  p1 = Computer.new

  g = Mastermind::Game.new(p1, p2)
  g.play
end
