require 'byebug'
require 'colorize'

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

  def setup(bombs=nil)
    bombs ||= @size ** 2 / 10
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
  def self.get_color(num)
    colors = { 1 => :blue,
               2 => :green,
               3 => :red,
               4 => :magenta,
               5 => :light_blue,
               6 => :cyan,
               7 => :light_red,
               8 => :yellow
             }
    colors[num]
  end

  def initialize(flagged=false)
    @flagged = flagged
    @exposed = false
    @numerized = nil
  end

  def to_s
    if @numerized
      color = Tile.get_color(@numerized)
      @numerized.to_s.colorize(color)
    elsif @exposed
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
  def initialize(board, size, bombs)
    @size = size
    @bombs = bombs
    @board = board
    @board.setup(bombs)
    @won = nil
  end

  def move(pos)
    tile = @board[pos]
    if tile.is_a?(Bomb)
      @board.render
      puts "YA LOSE!!"
      return
    else
      run(pos)
    end
  end

  def run(start)
    all_seen_tiles = []
    queue = [start]
    until queue.empty?
      pos = queue.pop
      next if all_seen_tiles.include?(pos)
      all_seen_tiles << pos
      tile = @board[pos]
      tile.expose
      adj_pos = @board.find_adjacent_positions(pos)
      adj_tiles = adj_pos.map { |pos| @board[pos] }
      bombs = adj_tiles.select { |tile| tile.is_a?(Bomb) }.count
      if bombs > 0
        tile.numerize(bombs)
      else
        queue.concat(adj_pos)
      end
    end
    @board.render

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
  g = Game.new(b, 9, nil)
  g.move([5,5])
end
