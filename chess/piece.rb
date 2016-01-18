class Piece
  attr_reader :pos, :color, :board, :white, :black
  
  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
    @white, @black = "\u0078", "\u0078"
  end
  
  def sym
    @color == :white ? @white : @black
  end
  
  def move(pos)
    @pos = pos
  end

  def present?
    true
  end
  
  def display
    sym.encode('utf-8')
  end

  def to_s
    " #{display} "
  end
end

class NullPiece < Piece
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
  end
  
  def present?
    false
  end
end

class SlidingPiece < Piece
  attr_reader :straights, :angles
  
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
    @straights = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @angles = [[-1, 1], [1, 1], [1, -1], [-1, -1]]
  end
  
  def move_dirs
    @straights.concat(@angles)
  end
end

class SteppingPiece < Piece
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
  end
end

class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265D", "\u2657"
  end
  
  def move_dirs
    @angles
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265C", "\u2656"
  end
  
  def move_dirs
    @straights
  end
end

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265B", "\u2655"
  end
end

class Knight < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265E", "\u2658"
  end
end

class King < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265A", "\u2654"
  end
end

class Pawn < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265F", "\u2659"
  end
end

b = "board"

piece = Piece.new([1,1], :black, b)
bishop = Bishop.new([2,2], :white, b)
np = NullPiece.new([3,3], nil, b)
pa = Pawn.new([1,1], :black, b)
ro = Rook.new([1,1], :white, b)
qu = Queen.new([1,1], :black, b)
kn = Knight.new([2,2], :white, b)
ki = King.new([3,3], :black, b)

# p piece.to_s
p bishop.to_s
p bishop.move_dirs
p ro.move_dirs
p qu.move_dirs
# p np.to_s
# p pa.to_s
# p ro.to_s
# p qu.to_s
# p kn.to_s
# p ki.to_s