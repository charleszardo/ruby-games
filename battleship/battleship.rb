require 'colorize'
require 'byebug'

module Battleship
  class Game
    SHIPS = { :a => {:name => "aircraft carrier", :size =>5, :color => :red},
              :b => {:name => "battleship", :size =>4, :color => :green},
              :s => {:name => "submarine", :size =>3, :color => :blue},
              :d => {:name => "destroyer", :size =>3, :color => :magenta},
              :p => {:name => "patrol boat", :size =>2, :color => :cyan}
    }
    
    attr_reader :game_board, :player
    
    def initialize(player=Battleship::Human.new)
      @player = player
      @game_board = Battleship::Board.new
      setup_board
    end
    
    def setup_board
      SHIPS.keys.shuffle.each do |ship|
        @game_board.populate_grid(ship, SHIPS[ship])
      end
    end
    
    def ship_arr
      @game_board.flatten.select {|coord| !coord.nil?}
    end
    
    def play
      rounds = 0
      until game_over?
        play_turn
        rounds += 1
      end
    end
    
    def play_turn
      valid_attack = false
      until valid_attack
        attack = @player.make_move
        if valid_move?(attack)
          valid_attack = true
        else
          puts "-----that's not a valid move!"
        end
      end
      
      attack = attack.map {|coord| coord.to_i }
      puts "you won!"
    end
    
    def play_turn
      attack = get_attack
      response = {:ship => nil, :loc => attack, :sunk => false}
      
      if @game_board.open_space?(attack)
        puts "you missed!"
        @player.board[attack[0], attack[1]] = "X"
      else
        ship = @game_board[attack[0], attack[1]]
        @player.board[attack[0], attack[1]] = ship.to_s.colorize(SHIPS[ship][:color])
        @game_board[attack[0], attack[1]] = "*"
        response[:ship] = ship
        if ship_arr.include?(ship)
          puts "you hit a ship!"
        else
          name = SHIPS[ship][:name]
          response[:sunk] = true
          puts "you sunk a #{name}!"
        end
      end
      @player.receive_attack_response(response)
      
      puts ""
      @player.show_board
      puts ""
    end

    def get_attack
      while true
        attack = @player.make_move
        if valid_move?(attack)
          return attack.map {|coord| coord.to_i }
        else
          puts "-----that's not a valid move!"
        end
      end
    end
    
    def valid_move?(move)
      unless move.length == 2 && move.all? { |coord| coord.is_a?(Fixnum) }
        return false
      end
      @game_board.in_range?(move)
    end
    
    def game_over?
      count == 0
    end
    
    def count
      ship_count = 0
      pieces = ship_arr
      SHIPS.keys.each {|ship| ship_count += 1 if pieces.include?ship}
      ship_count
    end
  end
  
  class Board
    attr_reader :grid, :size
    
    ACTIONS = [[0,1],
               [0,-1],
               [1,0],
               [-1,0]]
    
    def initialize(size=10)
      @size = size
      @grid = Array.new(size) do |row|
        Array.new(size)
      end
    end
    
    def display
      puts (0..9).to_a.unshift(" ").join(" ")
      row_num = 0
      @grid.each do |row|
        r = row.map do |spot|
          spot.nil? ? "_" : spot
        end
        r.unshift(row_num.to_s)
        puts r.join(" ")
        row_num += 1
      end
    end
    
    def [](row,col)
      @grid[row][col]
    end
    
    def []=(row,col,val)
      @grid[row][col] = val
    end
    
    def flatten
      @grid.flatten
    end
    
    def populate_grid(symbol, ship)
      coords = find_placement(ship[:size])
      coords.each do |coord|
        self[coord[0],coord[1]] = symbol
      end
    end
    
    def find_placement(size)
      placed = false
      until placed
        start = self.random_loc
        action = ACTIONS.sample
        coords = [start.dup]
        (size-1).times do
          start[0] += action[0]
          start[1] += action[1]
          coords << start.dup
        end
        placed = true if coords.all? { |coord| in_range?(coord) && open_space?(coord)}
      end
      coords
    end
    
    def in_range?(pos)
      pos[0] >= 0 && pos[0] < @grid.length && pos[1] >=0 && pos[1] < @grid.length
    end
    
    def open_space?(pos)
      self[pos[0],pos[1]].nil?
    end
    
    def random_loc
      x, y = (0...@size).to_a.sample, (0...@size).to_a.sample
      [x,y]
    end
  end
  
  class Player
    attr_accessor :board
    
    def initialize
      @board = Battleship::Board.new
      @board_size = @board.size
      @last_move = nil
      @direction = nil
      @base_pos = nil
      @current_moves = []
      @current_ship = []
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
  
  class Human < Player
    def make_move
      puts "make an attack (format: 0,1)"
      move = gets.chomp.split(",").map { |coord| coord.to_i }
      puts ""
      move
    end
    
    def show_board
      @board.display
    end
  end
  
  class Computer < Player
    def make_move
      if !@last_move
        # first move
        random_move
      elsif @last_move[:sunk]
        # ship sunk, start over
        @direction = nil
        @base_pos = nil
        @current_ship = []
        random_move
      elsif !@base_pos && !@last_move[:ship]
        # didn't get a hit last round, not pursuing anything
        random_move
      elsif !@base_pos && @last_move[:ship]
        # got a hit last round, begin figuring out where the ship is
        @base_pos = @last_move[:loc]
        find_rest_of_ship
      elsif @base_pos && !@direction && !@last_move[:ship]
        # still haven't figured out which direction this ship is in from the beginning hit
        find_rest_of_ship
      elsif @base_pos && !@direction && @last_move[:ship]
        # now we know what direction to go in
        determine_direction
        continue_attacking_ship
      elsif @base_pos && @direction && !@last_move[:ship]
        reverse_direction
        continue_attacking_ship
        # go back to other end
      elsif @base_pos && @direction && @last_move[:ship]
        # on the trail, keep moving in this direction
      else
        # I DON'T KNOW!!!
      end
    end
    
    def find_rest_of_ship
      temp_moves = []
      @deltas.each do |delta|
        new_delta = []
        new_delta << delta[0] + @base_pos[0]
        new_delta << delta[1] + @base_pos[1]
        temp_moves << new_delta
      end
      move = temp_moves.select { |move| @moves.include?(move) }.sample
      move
    end
    
    def determine_direction
      debugger
      @direction = []
      last_move_loc = @last_move[:loc]
      @direction << last_move_loc[0] - @base_pos[0]
      @direction << last_move_loc[1] - @base_pos[1]
    end
    
    def reverse_direction
      @direction.map! { |coord| coord *= -1}
      @last_move[:loc] = @base_pos
    end
    
    def continue_attacking_ship
      attack = []
      attack << @last_move[:loc][0] + @direction[0]
      attack << @last_move[:loc][1] + @direction[1]
      attack
    end
    
    def smart_move
      if @direction
        
      else
      end
    end
    
    def random_move
      @moves.sample
    end
  end
end

if $PROGRAM_NAME == __FILE__
  c = Battleship::Computer.new
  g = Battleship::Game.new(c)
  g.play
end


