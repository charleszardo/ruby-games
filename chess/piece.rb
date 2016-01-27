class Piece
  attr_reader :pos, :color, :board
  
  def initialize(pos, color, board)
    @pos, @color, @board, @moved = pos, color, board, false
    @white, @black = "\u0078", "\u0078"
  end
  
  def sym
    @color == :white ? @white : @black
  end
  
  def move(pos)
    @moved = true
    @pos = pos
  end
  
  def moves
    # possible refactor with map
    potential = []
    move_dirs.each do |delta|
      next_move = add_coords(@pos, delta)
      potential << next_move if board.valid_move?(@pos, next_move)
    end
    potential
  end
  
  def find_moves(test_pos, delta)
    # holder
  end
  
  def move_dirs
    []
  end
  
  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end
  
  def move_into_check?(end_pos)
    dup_board = Board.dup(@board)
    dup_board.move!(@pos, end_pos)
    dup_board.in_check?(@color)
  end

  def present?
    true
  end
  
  def space_empty?(coord)
    board.empty?(coord)
  end
  
  def display
    sym.encode('utf-8')
  end

  def to_s
    " #{display} "
  end
  
  def add_coords(coord1, coord2)
    [coord1[0] + coord2[0],
     coord1[1] + coord2[1]]
  end
end

class NullPiece < Piece
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
  end
  
  def present?
    false
  end
end

class SlidingPiece < Piece
  attr_reader :straights, :angles
  
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
    @straights = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @angles = [[-1, 1], [1, 1], [1, -1], [-1, -1]]
  end
  
  def move_dirs
    @straights.concat(@angles)
  end
  
  def moves
    # possible refactor with map
    potential = []
    move_dirs.each do |move|
      moves = find_moves(@pos, @pos, move)
      potential.concat(moves) if !moves.empty?
    end
    potential
  end
  
  def find_moves(start_pos, test_pos, delta)
    next_move = add_coords(test_pos, delta)
    if !board.valid_move?(start_pos, next_move)
      []
    elsif @board[next_move].class != NullPiece
      [next_move]
    else
      find_moves(start_pos, next_move, delta) << next_move
    end
  end
end

class SteppingPiece < Piece
  def initialize(pos, color=nil, board)
    super
    @white, @black = "\u0020", "\u0020"
  end
end

class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265D", "\u2657"
  end
  
  def move_dirs
    @angles
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265C", "\u2656"
  end
  
  def move_dirs
    @straights
  end
end

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265B", "\u2655"
  end
end

class Knight < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265E", "\u2658"
  end
  
  def move_dirs
    # need to test
    [[2, 1], [2, -1], [-2, 1], [-2, -1],
     [1, 2], [1, -2], [-1, 2], [-1, -2]]
  end
end

class King < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265A", "\u2654"
  end
  
  def move_dirs
    [[-1, 1], [-1, 0], [-1, -1],
     [1, 1], [1, 0], [1, -1],
     [0, 1], [0, -1]]
  end
end

class Pawn < Piece
  def initialize(pos, color, board)
    super
    @white, @black = "\u265F", "\u2659"
  end
  
  def move_dirs
    # double check to make user color-based direction is correct
    dir = color == :black ? 1 : -1
    straights = [[dir, 0]]
    straights << [dir * 2, 0] if !@moved
    angles = [[dir, -1], [dir, 1]]
    
    straights.select! do |diff|
      new_pos = add_coords(diff, pos)
      space_empty?(new_pos)
    end 
    
    angles.select! do |diff|
      new_pos = add_coords(diff, pos)
      !space_empty?(new_pos)
    end
    
    straights.concat(angles)
  end
  
  
end