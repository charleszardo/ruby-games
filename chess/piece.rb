class Piece
  attr_reader :display, :pos
  
  def initialize(pos)
    @pos = pos
    @display = "x"
  end
  
  def move(pos)
    @pos = pos
  end

  def present?
    true
  end

  def to_s
    " x "
  end
end

class NullPiece < Piece
  def present?
    false
  end

  def to_s
    "   "
  end
end

class Bishop < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end

class Rook < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end

class Queen < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end

class Knight < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end

class King < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end

class Pawn < Piece
  def initialize(pos)
    super
    @display = "B"
  end
end