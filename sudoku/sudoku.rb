class Tile
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
      puts row.join(" ")
    end
  end

  def solved?

  end

  def rows_solved?
    @grid.all? { |row| row.sort == [1, 2, 3, 4, 5, 6, 7, 8, 9]}
  end

  def cols_solved?

  end

  def boxes_solved?

  end
end
