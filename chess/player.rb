require_relative "display"

class Player
  def initialize(board, color)
    @display = Display.new(board)
    @color = color
  end

  def move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end