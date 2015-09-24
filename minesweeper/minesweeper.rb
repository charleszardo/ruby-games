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

  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord < @size }
  end

  def find_adjacent_tiles(tile)
    # TODO
    x, y = tile
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
    @won = nil
  end

  def move(pos)
    tile = @board[pos]
    tile.expose
    if tile.is_a?(Bomb)
      return
    else

    end
  end

  def run(start)
    all_seen_tiles = [start]
    queue = [start]
    until queue.empty?
      tile = queue.pop
      adj_tiles = @board.find_adjacent_tiles(tile)
      bombs = adj_tiles.select { |tile| tile.is_a?(Bomb) }.count
      tile.expose
      if bombs > 0
        tile.numerize(bombs)
      else
        queue << adj_tiles
      end
    end
  end

  def game_over?
    exposed = @board.flatten.select { |tile| tile.exposed? }
    if exposed.count == (@size**2 - @bombs)
      @won = true
      return true
    elsif exposed.any? { |tile| tile.is_a?(Bomb) }
      @won = false
      return true
    end
    false
  end
end
