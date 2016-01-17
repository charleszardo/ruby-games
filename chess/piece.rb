class Piece
  def initialize(pos, color)
    @pos, @color = pos, color
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
  def initialize(pos, color=nil)
    @pos, @color = pos, color
    @white, @black = "\u0020", "\u0020"
  end
  
  def present?
    false
  end
end

class Bishop < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265D", "\u2657"
  end
end

class Rook < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265C", "\u2656"
  end
end

class Queen < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265B", "\u2655"
  end
end

class Knight < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265E", "\u2658"
  end
end

class King < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265A", "\u2654"
  end
end

class Pawn < Piece
  def initialize(pos, color)
    @pos, @color = pos, color
    @white, @black = "\u265F", "\u2659"
  end
end

piece = Piece.new([1,1], :black)
bishop = Bishop.new([2,2], :white)
np = NullPiece.new([3,3])
pa = Pawn.new([1,1], :black)
ro = Rook.new([1,1], :white)
qu = Queen.new([1,1], :black)
kn = Knight.new([2,2], :white)
ki = King.new([3,3], :black)

p piece.to_s
p bishop.to_s
p np.to_s
p pa.to_s
p ro.to_s
p qu.to_s
p kn.to_s
p ki.to_s