class Maze
  attr_reader :grid

  def self.from_file(file)
    grid = []
    File.open(file).each do |l|
      grid << l.chomp.split("").map do |val|
        Tile.create_tile(val)
      end
    end

    Maze.new(grid)
  end

  def initialize(grid)
    @grid = grid
  end

  def render
    @grid.each do |row|
      puts row.map { |tile| tile.to_s }.join("")
    end
  end

  def find_start
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        return [row_idx, col_idx] if tile.is_a?(Start)
      end
    end
  end

  def solve
    start = find_start
  end
end

class Tile
  def self.create_tile(val)
    case val
    when "*"
      Wall.new("*")
    when " "
      Space.new(" ")
    when "S"
      Start.new("S")
    when "E"
      End.new("E")
    end
  end

  def initialize(val)
    @val = val
  end

  def to_s
    @val
  end
end

class Start < Tile
end

class End < Tile
end

class Wall < Tile
end

class Space < Tile
end

m = Maze.from_file('maze.txt')
p m.find_start
