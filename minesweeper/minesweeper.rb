class Board
  attr_reader :grid

  def initialize(size=9)
    @size = size
    @grid = Array.new(size) { Array.new(size) { Tile.new }}
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    @grid[x][y] = val
  end

  def flatten
    @grid.flatten
  end

  def render
    @grid.each do |row|
      puts row.join(" | ")
    end
    nil
  end

  def setup(bombs=3)
    bomb_list = []
    until bomb_list.size == bombs
      pos = Array.new(2) { rand(@size) }
      bomb_list << pos unless bomb_list.include?(pos)
    end

    bomb_list.each { |bomb| self[bomb] = Bomb.new }
  end
end

class Tile
  def initialize(flagged=false)
    @flagged = flagged
    @exposed = false
  end

  def to_s
    if @exposed
      "X"
    else
      " "
    end
  end

  def expose
    @exposed = true
  end

  def exposed?
    @exposed
  end
end

class Bomb < Tile
  def to_s
    "B"
  end
end

class Game
  def initialize(board, size=9, bombs=3)
    @size = size
    @bombs = bombs
    @board = board
    @board.setup(bombs)
  end

  def move

  end

  def game_over?
    exposed = @board.flatten.select { |tile| tile.exposed? }
    exposed.count == (@size**2 - @bombs) || exposed.any? { |tile| tile.is_a?(Bomb) }
  end
end
