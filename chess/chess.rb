require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :white)
    @player2 = Player.new(@board, :black)
    @current_player = @player1
    @turns = 0
  end
  
  def turn
    start_pos = @current_player.move
    end_pos = @current_player.move
    @board.move(start_pos, end_pos)
  rescue
    @current_player.receive_msg("invalid move. please try again")
    retry
  end
  
  def change_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def run
    puts "WASD or arrow keys to move the cursor, enter or space to confirm."
    # until @board.in_checkmate?
    until @turns >= 4
      turn
      change_players
      @turns += 1
    end
  end
end

Game.new.run
