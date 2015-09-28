require 'byebug'

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

  def find_adjacent_positions(pos)
    x, y = pos
    deltas = [[-1, 0], [-1, 1], [-1, -1], [0, 1], [0, -1], [1, 0], [1, 1], [1, -1]]
    adj_tiles = deltas.map { |x1, y1| [x + x1, y +y1] }.select { |pos| on_board?(pos) }
  end
end

class Tile
  def initialize(flagged=false)
    @flagged = flagged
    @exposed = false
    @numerized = nil
  end

  def to_s
    if @exposed
      "X"
    elsif @numerized
      @numerized.to_s
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

  def numerize(num)
    @numerized = num
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
    if tile.is_a?(Bomb)
      return
    else
      run(pos)
    end
  end

  def run(start)
    all_seen_tiles = [start]
    queue = [start]
    count = 0
    until queue.empty? || count > 10
      @board.render
      p " "
      pos = queue.pop
      all_seen_tiles << pos
      tile = @board[pos]
      adj_pos = @board.find_adjacent_positions(pos)
      adj_tiles = adj_pos.map { |pos| @board[pos] }
      bombs = adj_tiles.select { |tile| tile.is_a?(Bomb) }.count
      tile.expose
      if bombs > 0
        tile.numerize(bombs)
      else
        new_pos = adj_pos.select { |pos| !all_seen_tiles.include?(pos) }
        queue.concat(new_pos)
      end
      count += 1
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

if $PROGRAM_NAME == __FILE__
  b = Board.new
  g = Game.new(b)
  g.move([5,5])
end
