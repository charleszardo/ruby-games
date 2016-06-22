# require 'byebug'
require_relative 'piece'

class Board
  def self.dup(board)
    dup_board = Board.new
    template = board.grid
    template.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        loc = [row_idx, col_idx]
        piece, pos, color = col.class, col.pos, col.color
        piece = piece.new(pos, color, dup_board)
        dup_board[loc] = piece
      end
    end
    dup_board
  end
  
  attr_reader :grid, :size, :error_msg

  def initialize(grid=nil)
    @size = 8
    @grid = grid || Array.new(size) { |row| set_row(row, self) }
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end
  
  def rows
    @grid
  end
  
  def move!(start_pos, end_pos)
    raise 'invalid move' if !valid_move?(start_pos, end_pos)
    piece = self[start_pos]
    piece.move(end_pos)
    self[start_pos] = NullPiece.new(start_pos, nil, self)
    self[end_pos] = piece
  rescue
    retry
  end

  def move(start_pos, end_pos)
    vmoves = self[start_pos].valid_moves
    if !vmoves.include?(end_pos)
      raise 'invalid move'
    end
    move!(start_pos, end_pos)
  end

  def in_bounds?(pos)
    pos.all? { |num| num.between?(0,size-1)}
  end

  def empty?(pos)
    self[pos].is_a?(NullPiece)
  end
  
  def same_color?(pos1, pos2)
    return false if [pos1, pos2].any? { |pos| self[pos].class === NullPiece}
    self[pos1].color === self[pos2].color
  end

  def valid_move?(start_pos, end_pos)
    return false if !in_bounds?(start_pos)
    return false if !in_bounds?(end_pos)
    return false if self[start_pos].class === NullPiece
    return false if same_color?(start_pos, end_pos)
    true
  end

  def in_check?(color)
    king = find_pieces(King, color)[0]
    king_pos = king.pos
    check = false
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        space = self[[row_idx, col_idx]]
        if !space.is_a?(NullPiece) && space.color != color
          if space.moves.include?(king_pos)
            puts space
            check = true
            break
          end
        end
      end
    end
    check
  end
  
  def checkmate?(color)
    if in_check?(color)
      pieces = find_pieces(Piece, color)
      pieces.all? { |piece| piece.valid_moves.empty? }
    else
      false
    end
  end
  
  def in_checkmate?
    checkmate?(:white) || checkmate?(:black)
  end

  def find_pieces(piece, color)
    pieces = []
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        space = self[[row_idx, col_idx]]
        if space.is_a?(piece) && space.color == color
          pieces << space
        end
      end
    end
    pieces
  end

  def print
    @grid.each {|row| puts row.join(" | ") }
    nil
  end
  
  def set_row(row, board)
    color = row < 2 ? :black : :white
    pieces = nil
    if row == 0 || row == 7
      pieces = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]
      pieces.reverse! if color == :white
    elsif row == 1 || row == 6
      pieces = Array.new(size) { Pawn }
    else
      pieces = Array.new(size) { NullPiece }
    end
    
    populate_row(pieces, row, color, board)
  end
  
  def populate_row(pieces, row, color, board)
    row_pieces = []
    col = 0
    while col < size
      row_pieces << pieces[col].new([row, col], color, board)
      col += 1
    end
    row_pieces
  end
end