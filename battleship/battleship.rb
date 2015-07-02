module Battleship
  class Game
    def initialize
      
    end
    
    def play
      
    end
  end
  
  class Board
    attr_reader :grid
    
    def initialize(size=10)
      @grid = Array.new(size) do |row|
        Array.new(size)
      end
    end
    
    def display
      @grid.each do |row|
        r = row.map do |spot|
          spot.nil? ? "O" : spot
        end
        puts r.join(" ")
      end
    end
    
    def [](row,col)
      @grid[row][col]
    end
    
    def []=(row,col,val)
      @grid[row][col] = val
    end
    
    def in_range?(pos)
      pos[0] >= 0 && pos[0] < @grid.length && pos[1] >=0 && pos[1] < @grid.length
    end
  end
end

if $PROGRAM_NAME == __FILE__
  g = Battleship::Game.new
  b = Battleship::Board.new

  g.play
end


