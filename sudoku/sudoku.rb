# class Array
#   def my_transpose
#   dimension = self.first.count
#   cols = Array.new(dimension) { Array.new(dimension) }
#
#   dimension.times do |i|
#     dimension.times do |j|
#       cols[j][i] = self[i][j]
#     end
#   end
#
#   cols
# end

class Tile
  attr_reader :value

  def initialize(value, given)
    @value = value
    @given = given
    @displayed = @given ? true : false
  end

  def to_s
    @displayed ? @value.to_s : " "
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
    self[pos] = val
  end

  def [](pos)
    @grid[pos[0], pos[1]]
  end

  def []=(pos, val)
    @grid[pos[0], pos[1]] = val
  end

  def render
    @grid.each do |row|
      puts row.map(&:to_s).join(" | ")
      # puts row.map(&:to_s).join(" ")
    end
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
    sets = []
    (0..2).each do |far|
      (0..2).each do |outer|
        set = (0..2).map do |inner|
          factor = (3 * outer) + inner
          range_min = far * 3
          range_max = range_min + 2
          @grid[factor][range_min..range_max]
        end.flatten
        sets << set
      end
    end

    set_solved?(sets)
  end
end
