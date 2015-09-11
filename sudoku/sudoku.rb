require 'byebug'
require 'colorize'

class Tile
  attr_reader :value

  def initialize(value, given)
    @value = value
    @given = given
    @displayed = @given ? true : false
  end

  def change_value(new_value)
    @value = new_value unless given?
    display
  end

  def to_s
    if @given
      @value.to_s.colorize(:light_blue)
    else
      @displayed ? @value.to_s : " "
    end
  end

  def display
    @displayed = true
  end

  def erase
    unless given?
      @displayed = false
      @value = 0
    end
  end

  def given?
    @given
  end
end

class Board
  def self.from_file(file)
    grid = []
    File.open(file).each do |l|
      grid << l.chomp.split("").map do |val|
        val = val.to_i
        given = val == 0 ? false : true
        Tile.new(val, given)
      end
    end
    Board.new(grid)
  end

  def initialize(grid)
    @grid = grid
  end

  def update(pos, val)
    self[pos].change_value(val)
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end

  def render
    system "clear"
    @grid.each { |row| puts row.map(&:to_s).join(" | ") }
    nil
  end

  def solved?
    rows_solved? && cols_solved? && boxes_solved?
  end

  def set_solved?(set)
    set.all? { |row| row.map { |tile| tile.value.to_i }.sort == (1..9).to_a }
  end

  def rows_solved?
    set_solved?(@grid)
  end

  def cols_solved?
    set_solved?(@grid.transpose)
  end

  def boxes_solved?
    boxes = []
    (0..2).each do |far|
      (0..2).each do |outer|
        set = (0..2).map do |inner|
          factor = (3 * outer) + inner
          range_min = far * 3
          range_max = range_min + 2
          @grid[factor][range_min..range_max]
        end.flatten
        boxes << set
      end
    end

    set_solved?(boxes)
  end
end

class Game
  attr_accessor :board

  def initialize(puzzle)
    @board = Board.from_file(puzzle)
  end

  def play
    until @board.solved?
      @board.render
      make_move
    end
    @board.render
    puts 'you win!'
  end

  def make_move
    pos = get_pos
    val = get_val
    @board.update(pos, val)
  end

  def get_pos
    puts "Give me a pos i.e. 1 2"
    begin
      input = gets.chomp.split(" ")
      pos = input.map(&:to_i)
      raise ArgumentError.new unless valid_pos?(pos, input)
    rescue
      puts "invalid position!"
      retry
    end
    pos
  end

  def get_val
    puts "Give me a value"
    begin
      input = gets.chomp
      val = input.to_i
      raise ArgumentError.new unless valid_val?(val, input)
    rescue
      puts "invalid value!"
      retry
    end
    val
  end

  def valid_pos?(pos, input)
    pos.size == 2 && pos.all? { |num| num.between?(0, 8)} && pos.map(&:to_s) == input
  end

  def valid_val?(val, input)
    val.between?(1, 9) && val.to_s == input
  end
end
