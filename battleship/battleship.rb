require 'colorize'
require 'byebug'

class Game
  SHIPS = { :a => {:name => "aircraft carrier", :size =>5, :color => :red},
            :b => {:name => "battleship", :size =>4, :color => :green},
            :s => {:name => "submarine", :size =>3, :color => :blue},
            :d => {:name => "destroyer", :size =>3, :color => :magenta},
            :p => {:name => "patrol boat", :size =>2, :color => :cyan}
  }

  attr_reader :game_board, :player

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board1 = Battleship::Board.new
    @board2 = Battleship::Board.new
    @player = player1
    @game_board = @board1
    setup_board(@board1)
    setup_board(@board2)
  end

  def setup_board(board)
    SHIPS.keys.shuffle.each do |ship|
      board.populate_grid(ship, SHIPS[ship])
    end
  end

  def ship_arr
    @game_board.flatten.select {|coord| !coord.nil?}
  end

  def play
    rounds = 0
    until game_over?
      play_turn
      change_players
      rounds += 1
    end
    change_players
    closing_credits
  end

  def play_turn
    puts "GOT HERE!"
    sleep(2)
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

  def change_players
    @player = [@player1, @player2].select { |player| player != @player }.first
    @board = [@board1, @board2].select { |board| board != @board }.first
  end

  def closing_credits
    name = @player == @player1 ? "Player 1" : "Player 2"
    puts "GAME OVER. #{name} wins."
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
    attack = get_attack
    p attack
    attack
  end

  def get_attack
    if first_move?
      first_move
    elsif sunk_ship?
      post_sunk_move
    elsif searching_for_ship?
      random_move
    elsif first_hit?
      handle_first_hit
    elsif in_pursuit?
      if searching_for_rest_of_ship?
        find_rest_of_ship
      elsif found_different_ship?
        @diff_ship = true
        handle_different_ship
      else
        @diff_ship = false
        determine_next_move
      end
    else
      puts "I DON'T KNOW!!!"
    end
  end

  def first_move?
    # determine whether first move
    !@last_move
  end

  def sunk_ship?
    @last_move[:sunk]
  end

  def searching_for_ship?
    !@current_ship && !@last_move[:ship]
  end

  def searching_for_rest_of_ship?
    @base_pos && !@direction && !@last_move[:ship]
  end

  def found_different_ship?
    @last_move[:ship] != @current_ship
  end

  def in_pursuit?
    @current_ship
  end

  def first_hit?
    !@base_pos && @last_move[:ship] && !@current_ship
  end

  def first_move
    random_move
  end

  def post_sunk_move
    @direction, @base_pos, @current_ship = nil, nil, nil
    if @ship_queue.empty?
      random_move
    else
      handle_ship_queue
    end
  end

  def handle_first_hit
    @base_pos = @last_move[:loc]
    @current_ship = @last_move[:ship]
    find_rest_of_ship
  end

  def handle_different_ship
    if @ship_queue[@last_move[:ship]]
      @ship_queue[@last_move[:ship]] << @last_move[:loc]
    else
      @ship_queue[@last_move[:ship]] = [@last_move[:loc]]
    end
    determine_next_move
  end

  def handle_ship_queue
    # todo.......
  end

  def determine_next_move
    if @base_pos && !@direction && @last_move[:ship]
      # now we know what direction to go in
      check_ship_type
      determine_direction
      attack = continue_attacking_ship
      if !@moves.include?(attack)
        reverse_direction
        return continue_attacking_ship
      end
      attack
    elsif @base_pos && @direction && !@last_move[:ship]
      reverse_direction
      continue_attacking_ship
      # go back to other end and attack
    elsif @base_pos && @direction && @last_move[:ship]
      # on the trail, keep moving in this direction
      check_ship_type
      continue_attacking_ship
    end
  end

  def attack_pos(pos)
    pos
  end

  def check_ship_type
    if @last_move[:ship] != @current_ship
      @ship_queue[@last_move[:ship]] = [@last_move[:loc]]
      return find_rest_of_ship
    end
  end

  def check_ship_queue
    unless @ship_queue.empty?
      ship = @ship_queue.keys.sample
      locs = @ship_queue[ship]
      return locs.sample
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

  def random_move
    @moves.sample
  end
end

c = Battleship::Computer.new
h = Battleship::Human.new
g = Battleship::Game.new(h, c)
g.play
