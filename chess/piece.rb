class Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u0078"
    @pos = pos
    @display = @sym.encode('utf-8')
  end
  
  def move(pos)
    @pos = pos
  end

  def present?
    true
  end

  def to_s
    " #{display} "
  end
end

class NullPiece < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u0020"
    @pos = pos
    @display = @sym.encode('utf-8')
  end
  
  def present?
    false
  end
end

class Bishop < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2657"
    # black: 265D
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

class Rook < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2656"
    # black: 265C
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

class Queen < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2655"
    # black: 265B
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

class Knight < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2658"
    # black: 265E
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

class King < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2654"
    # black: 265A
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

class Pawn < Piece
  attr_reader :pos, :display
  
  def initialize(pos)
    @sym = "\u2659"
    # black: 265F
    @pos = pos
    @display = @sym.encode('utf-8')
  end
end

# piece = Piece.new([1,1])
# bishop = Bishop.new([2,2])
# np = NullPiece.new([3,3])
# pa = Pawn.new([1,1])
# ro = Rook.new([1,1])
# qu = Queen.new([1,1])
# kn = Knight.new([2,2])
# ki = King.new([3,3])
#
# p piece.to_s
# p bishop.to_s
# p np.to_s
# p pa.to_s
# p ro.to_s
# p qu.to_s
# p kn.to_s
# p ki.to_s