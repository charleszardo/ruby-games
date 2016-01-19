require 'byebug'
require_relative 'piece'

class Board
  attr_reader :grid, :size

  def initialize
    @size = 8
    @grid = Array.new(size) { |row| set_row(row, self) }
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, val)
    puts 'here'
    @grid[pos[0]][pos[1]] = val
  end
  
  def rows
    @grid
  end

  def move(start_pos, end_pos)
    raise 'invalid move' if !valid_move(start_pos, end_pos)
    piece = self[start_pos]
    piece.move(end_pos)
    self[start_pos] = nil
    self[end_pos] = piece
  rescue
    puts "try again"
    retry
  end

  def in_bounds?(pos)
    pos.all? { |num| num.between?(0,size)}
  end

  def empty?(pos)
    self[pos].is_a?(NullPiece)
  end

  def valid_move(start_pos, end_pos)
    # debugger
    # will need to change fourth requirement depending on piece/rules
    val_start = in_bounds?(start_pos)
    val_end = in_bounds?(end_pos)
    nil_start = !self[start_pos].nil?
    # nil_end = self[end_pos[0], end_pos[1]].nil?
    val_start && val_end && nil_start #&& nil_end
  end

  def in_check?(color)
    debugger
    king = find_piece(King, color)[0]
    king_pos = king.pos
    check = false
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        space = self[[row_idx, col_idx]]
        if !space.is_a?(NullPiece) && space.color != color &&
          space.moves.include?(king_pos)
          check = true
          break
        end
      end
    end
    check
  end

  def find_piece(piece, color)
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
    @grid.each { |row| puts row.join(" | ") }
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