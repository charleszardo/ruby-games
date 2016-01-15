class Display
  attr_reader :board
  
  def initialize(board)
    @board = board
  end
  
  def print
    board.grid.each do |row|
      puts row.join(" | ")
    end
  end
end