class Board
  attr_reader :grid
  
  def initialize
    size = 8
    @grid = Array.new(size) do |row|
      Array.new(size) { "x"}
    end
  end
  
  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, val)
    @grid[row][col] = val
  end
  
  def move(start_pos, end_pos)
    piece = self[start_pos[0], start_pos[1]]
    self[start_pos[0], start_pos[1]] = nil
    self[end_pos[0], end_pos[1]] = piece
  end
  
  def print
    @grid.each do |row|
      puts row.join(" | ")
    end
  end
end