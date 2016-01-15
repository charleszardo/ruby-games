class Piece
  attr_reader :display
  
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

class NullPiece
  def present?
    false
  end

  def to_s
    "   "
  end
end