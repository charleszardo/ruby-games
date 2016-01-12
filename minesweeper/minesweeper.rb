require 'byebug'
require 'colorize'
require 'yaml'

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

  def bomb_count
    self.flatten.select { |tile| tile.is_a?(Bomb) }.count
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
    @symbol = "X"
  end

  def to_s
    if @flagged
      "F".colorize(:red)
    elsif @numerized
      color = Tile.get_color(@numerized)
      @numerized.to_s.colorize(color)
    elsif @exposed
      @symbol
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

  def flagged?
    @flagged
  end

  def flag
    @flagged = true
  end

  def numerize(num)
    @numerized = num
  end
end

class Bomb < Tile
  def initialize
    super
    @symbol = "B"
  end
end

class Game
  attr_reader :size, :board
  
  def initialize(size=9, board=Board.new(size))
    @size, @board, @won, @all_seen_tiles = size, board, nil, []
    @board.setup
    @bombs = @board.bomb_count
  end

  def play
    @board.render
    until game_over?
      command = get_command
      if command == :save
        @board.render
        next
      end
      pos = get_position
      if command == :reveal
        reveal(pos)
      else
        flag(pos)
      end
      @board.render
    end

    puts "Congrats, you won!" if @won
  end

  def get_command
    loop do
      puts "Reveal (1), Flag (2), or Save (s)?"
      command = gets.chomp
      valid_commands = ["1", "2"]
      if command.downcase == "s"
        puts self.to_yaml
        return :save
      elsif valid_commands.include?(command)
        return num_to_command(command)
      else
        puts "invalid command."
      end
    end
  end

  def get_position
    puts "give me a position (ex: 1,2)"
    pos = gets.chomp
    loop do
      if valid_coord?(pos)
        return pos.split(",").map { |coord| coord.to_i }
      else
        puts "invalid coordinate"
      end
    end
  end

  def valid_coord?(pos)
    pos = pos.split(",")
    pos_mapped = pos.map { |coord| coord.to_i }
    pos.size == 2 && pos[0].to_i.to_s == pos[0] && pos[1].to_i.to_s == pos[1] &&
    @board.on_board?(pos_mapped)
  end

  def num_to_command(num)
    commands = { "1" => :reveal, "2" => :flag }
    commands[num]
  end

  def reveal(pos)
    tile = @board[pos]

    if tile.flagged?
      puts "Tile is flagged.  Cannot be revealed."
    elsif tile.is_a?(Bomb)
      @board.render
      puts "YA LOSE!!"
      return
    else
      run(pos)
    end
  end

  def flag(pos)
    tile = @board[pos]
    tile.flag
  end

  def run(start)
    queue = [start]
    until queue.empty?
      pos = queue.pop
      tile = @board[pos]
      next if @all_seen_tiles.include?(pos) || tile.flagged?
      @all_seen_tiles << pos
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
  g = Game.new(5)
  g.play
end
