require "colorize"
require_relative "cursorable"

class Display
  include Cursorable
  
  attr_reader :board

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg, color: :white }
  end

  def render(msg="")
    # system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    puts msg
    build_grid.each do |row| 
      puts row.join
      # row.each do |space|
      #   p space
      # end
      # row_display = []
#       row.each do |space|
#           row_display << (space.is_a?(Piece) ? space.display : " ")
#       end
#       puts row_display.join(" | ")
    end
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