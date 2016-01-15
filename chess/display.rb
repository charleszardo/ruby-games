class Display
  attr_reader :board
  
  def initialize(board)
    @board = board
  end
  
  def print
    board.grid.each do |row|
      row_display = []
      row.each do |space|
          row_display << (space.is_a?(Piece) ? space.display : " ")
      end
      puts row_display.join(" | ")
    end
  end
end