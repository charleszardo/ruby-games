require 'byebug'
require_relative 'piece'

class Board
  attr_reader :grid, :size

  def initialize
    @size = 8
    @grid = Array.new(size) do |row|
      if row == 0 || row == 7
        back_row(row, color, self)
      elsif row == 1 || row == 6
        front_row(row, color, self)
      else
        Array.new(size) do |col|
          pos = [row, col]
          NullPiece.new(pos, nil, self)
        end
      end
    end
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, val)
    @grid[row][col] = val
  end

  def rows
    @grid
  end

  def move(start_pos, end_pos)
    raise 'invalid move' if !valid_move(start_pos, end_pos)
    piece = self[start_pos[0], start_pos[1]]
    piece.move(end_pos)
    self[start_pos[0], start_pos[1]] = nil
    self[end_pos[0], end_pos[1]] = piece
  rescue
    puts "try again"
    retry
  end

  def in_bounds?(pos)
    pos.all? { |num| num.between?(0,size)}
  end

  def empty?(pos)
    self[pos[0], pos[1]].is_a?(NullPiece)
  end

  def valid_move(start_pos, end_pos)
    # debugger
    # will need to change fourth requirement depending on piece/rules
    val_start = in_bounds?(start_pos)
    val_end = in_bounds?(end_pos)
    nil_start = !self[start_pos[0], start_pos[1]].nil?
    # nil_end = self[end_pos[0], end_pos[1]].nil?
    val_start && val_end && nil_start #&& nil_end
  end

  def in_check?(color)
    king = find_piece(King, color)
    king_pos = king.pos
    check = false
    @grid.each do |row|
      row.each do |col|
        space = self[row, col]
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
    @grid.each do |row|
      row.each do |col|
        space = self[row, col]
        if space.is_a?(piece) && space.color == color
          pieces << space
        end
      end
    end
    pieces
  end

  def print
    @grid.each do |row|
      puts row.join(" | ")
    end
    nil
  end
  
  def create_row(row, board)
    color = row < 2 ? :black : :white
    pieces = nil
    if row == 0 || row == 7
      pieces = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]
      pieces.reverse! if color == :white
      populate_row(pieces, row, color, board)
    elsif row == 1 || row == 6
      
    else
      
    end
  end
  
  def populate_row(pieces, row, color, board)
    
  end
  
  def back_row(row, color, board)
    row_pieces = []
    col = 0
    
    while col < 8
      row_pieces << pieces[col].new([row, col], color, board)
      col += 1
    end
    row_pieces
  end
  
  def front_row(row, color, board)
    row_pieces = []
    col = 0
    while col < 8
      row_pieces << Pawn.new([row, col], color, board)
      col += 1
    end
    row_pieces
  end
end