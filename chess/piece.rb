class Piece
  attr_reader :display
  
  def initialize(pos)
    @pos = pos
    @display = "x"
  end
  
  def move(pos)
    @pos = pos
  end
  
  
end