require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @player = Player.new(@board)
    @turns = 0
  end

  def run
    puts "Mark all the spaces on the board!"
    puts "WASD or arrow keys to move the cursor, enter or space to confirm."
    until @turns == 10
      p @turns
      @turns += 1
      pos = @player.move
      puts pos
      # @board.mark(pos)
    end
    puts "Hooray, the board is filled!"
  end
end

if __FILE__ == $PROGRAM_NAME
  # Game.new.run
end

b = Board.new
piece = Piece.new([1,1], :black, b)
bishop = Bishop.new([2,2], :white, b)
np = NullPiece.new([3,3], nil, b)
pa = Pawn.new([1,1], :black, b)
ro = Rook.new([1,1], :white, b)
qu = Queen.new([1,1], :black, b)
kn = Knight.new([2,2], :white, b)
ki = King.new([3,3], :black, b)

p b.print
p bishop.moves