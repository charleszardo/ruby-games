class Player
  attr_accessor :board

  def initialize(board)
    @board = Board.new
    @board_size = @board.size
    @last_move = nil
    @direction = nil
    @base_pos = nil
    @current_moves = []
    @current_ship = nil
    @ship_queue = {}
    @deltas = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    generate_moves
  end

  def generate_moves
    @moves = []
    (0...@board_size).each do |x|
      (0...@board_size).each do |y|
        @moves << [x, y].map {|loc| loc }
      end
    end
  end

  def show_board
    @board.display
  end

  def receive_attack_response(response = {})
    defaults = {
      :ship => nil,
      :loc => nil,
      :sunk => false
    }

    response = defaults.merge(response)
    @moves.delete(response[:loc])
    @last_move = response
  end
end