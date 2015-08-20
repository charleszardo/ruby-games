class Card
  attr_reader :value
  
  def initialize(value=nil)
    @value = value
    @facing = :down
  end
  
  def hide
    @facing = :down
  end
  
  def reveal
    @facing = :up
    @value
  end
  
  def to_s
    puts @value
  end
  
  def ==(other)
    value == other.value
  end
end

class Board
  def initialize(size=4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
  end
  
  def populate
    max = @size**2 / 2
    cards = (1..max).map {|n| [n,n] }.flatten
    cards.shuffle.each do |card|
    end
  end
  
  def [](x,y)
    @grid[x][y]
  end
  
  def index_to_grid_loc(index)
    x = index / @size)
    y = (index % @size)
    self[x,y]
  end
  
  def render
    
  end
  
  def won?
    
  end
  
  def reveal(guessed_pos)
    
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
end