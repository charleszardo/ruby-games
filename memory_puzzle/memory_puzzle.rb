class Card
  attr_reader :value
  
  def initialize(value=nil)
    @value = value
    @facing = :down
  end
  
  def exposed?
    @facing == :up
  end
  
  def hide
    @facing = :down
  end
  
  def reveal
    @facing = :up
    @value
  end
  
  def to_s
    @facing == :up ? @value.to_s : "X"
  end
  
  def ==(other)
    value == other.value
  end
end

class Board
  def initialize(size=4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    populate
  end
  
  def populate
    max = @size**2 / 2
    values = (1..max).map {|n| [n,n] }.flatten
    values.shuffle.each_with_index do |value, idx|
      card = Card.new(value)
      loc = index_to_grid_loc(idx)
      set_grid_loc(loc, card)
    end
    nil
  end
  
  def [](x, y)
    @grid[x][y]
  end
  
  def []=(x, y, value)
    @grid[x][y] = value
  end
  
  def index_to_grid_loc(index)
    x = (index / @size)
    y = (index % @size)
    [x,y]
  end
  
  def set_grid_loc(loc, value)
    self[*loc] = value
  end
  
  def render
    @grid.each do |row|
      puts row.map { |card| card.to_s }.join(" | ")
    end
  end
  
  def won?
    @grid.flatten.all? { |card| card.exposed? }
  end
  
  def reveal(loc)
    self[*loc].reveal
  end
end

class Game
  
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
end