require 'byebug'
require_relative 'piece'

class Board
  attr_reader :grid, :size
  
  def initialize
    @size = 8
    @grid = Array.new(size) do |row|
      Array.new(size) do |col|
        pos = [row, col]
        [Piece.new(pos), NullPiece.new(pos),
         Bishop.new(pos), Rook.new(pos),
         Queen.new(pos), Knight.new(pos),
         King.new(pos), Pawn.new(pos)].sample
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
  
  def valid_move(start_pos, end_pos)
    # debugger
    # will need to change fourth requirement depending on piece/rules
    val_start = in_bounds?(start_pos)
    val_end = in_bounds?(end_pos)
    nil_start = !self[start_pos[0], start_pos[1]].nil?
    # nil_end = self[end_pos[0], end_pos[1]].nil?
    val_start && val_end && nil_start #&& nil_end
  end
  
  def print
    @grid.each do |row|
      puts row.join(" | ")
    end
  end
end