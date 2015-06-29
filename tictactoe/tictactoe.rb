require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(3) { Array.new(3) }
    @wins = [[[0,0],[0,1],[0,2]],
             [[1,0],[1,1],[1,2]],
             [[2,0],[2,1],[2,2]],
             [[0,0],[1,0],[2,0]],
             [[0,1],[1,1],[2,1]],
             [[0,2],[1,2],[2,2]],
             [[0,0],[1,1],[2,2]],
             [[2,0],[1,1],[0,2]]
           ]
  end
  
  def print
    bar = "-----------"
    puts bar
    @grid.each do |row|
      temp_row = row.map do |el|
        if el.nil?
          "   "
        elsif el == :x
          " #{el} ".red
        elsif el == :o
          " #{el} ".blue
        end
      end
      puts temp_row.join("|")
      puts bar
    end
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end
  
  def won?
    @wins.each do |win|
      if win.all? {|coord| self[*coord] == :x}
        return true
      elsif win.all? {|coord| self[*coord] == :o}
        return true
      end
    end
    false
  end
  
  def empty?(pos)
    self[*pos].nil?
  end
  
  def place_mark(pos, mark)
    if self.empty?(pos)
      self[*pos] = mark
      return true
    else
      return false
    end
  end
end

class Game
  def initialize(board, player1, player2)
    @board, @player1, @player2 = board, player1, player2
    @turn = [@player1, @player2].sample
  end
  
  def play
    count = 0

    @board.print
    until @board.won? || count >= 5
      mark = (@turn == @player1 ? :x : :o)
      pos = @turn.move
      
      until @board.place_mark(pos,mark)
      end
      
      self.change_turn
      @board.print
      count += 1
    end
  end
  
  def change_turn
    if @turn == @player1
      @turn = @player2
    else
      @turn = @player1
    end
  end
end

class Player
  def move
  end
end

class Human < Player
  def move
    puts "make a move"
    move = gets.chomp
    move.split(',').map {|coord| coord.to_i}
  end
end

class Computer < Player
  def move
    puts "puter"
  end
end

board = Board.new

h1 = Human.new
h2 = Human.new

g = Game.new(board, h1, h2)
g.play