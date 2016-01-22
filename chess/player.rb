require_relative "display"

class Player
  def initialize(board, color)
    @display = Display.new(board)
    @color = color
    @msg = ""
  end

  def move
    result = nil
    until result
      @display.render(@msg)
      result = @display.get_input
      @msg = ""
    end
    result
  end
  
  def receive_msg(msg)
    puts "GOT THE MSG"
    @msg = msg
  end
end