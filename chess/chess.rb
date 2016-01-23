require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :white)
    @player2 = Player.new(@board, :black)
    @current_player = @player1
    @turns = 0
  end
  
  def turn
    start_pos = @current_player.move
    end_pos = @current_player.move
    @board.move(start_pos, end_pos)
  rescue
    @current_player.receive_msg("invalid move. please try again")
    retry
  end
  
  def change_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def run
    puts "WASD or arrow keys to move the cursor, enter or space to confirm."
    # until @board.in_checkmate?
    until @turns >= 4
      turn
      change_players
      @turns += 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run  #
  # g = Game.new
  # b = g.board
  # b.print
  # p b[[7,3]].moves
end

# b = Board.new
# b2 = Board.dup(b)
# # b.print#
# # b2.print
# piece = b2[[1,0]]
# # p piece.valid_moves
# b2.move([1,0], [2,0])
#
# # b.print
# b2.print
# piece = Piece.new([1,1], :black, b)
# bishop = Bishop.new([2,2], :white, b)
# np = NullPiece.new([3,3], nil, b)
# pa = Pawn.new([1,1], :black, b)
# ro = Rook.new([1,1], :white, b)
# qu = Queen.new([1,1], :black, b)
# kn = Knight.new([2,2], :white, b)
# ki = King.new([3,3], :black, b)

# p b.print
# d = Display.new(b)
# d.render
# p b.in_check?(:white)
# p bishop.moves