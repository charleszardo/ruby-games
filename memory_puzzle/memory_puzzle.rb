require 'byebug'

class Card
  attr_reader :value

  def initialize(value=nil)
    @value = value
    @facing = :down
  end

  def exposed?
    @facing == :up
  end

  def hide
    @facing = :down
  end

  def reveal
    @facing = :up
    @value
  end

  def to_s
    exposed? ? @value.to_s : "X"
  end

  def ==(other)
    value == other.value
  end
end

class Bomb < Card
  def to_s
    exposed? ? "B" : "X"
  end
end

class Board
  def initialize(size=4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    @play_with_bombs = true
    @bombs = []
    populate
  end

  def populate
    max = @size**2 / 2
    values = (1..max).map {|n| [n,n] }.flatten
    values.shuffle.each_with_index do |value, idx|
      card = Card.new(value)
      loc = index_to_grid_loc(idx)
      set_grid_loc(loc, card)
    end

    add_bombs
    nil
  end

  def add_bombs
    return unless @play_with_bombs
    ((@size - 2) / 2).times do
      x, y = random_board_loc
      val = self[x,y].value
      @bombs << self[x, y] = Bomb.new
      x, y = find_value_on_grid(val)
      @bombs << self[x, y] = Bomb.new
    end
  end

  def find_value_on_grid(val)
    (0...@size).each do |x|
      (0...@size).each do |y|
        return [x,y] if self[x,y].value == val
      end
    end
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, value)
    @grid[x][y] = value
  end

  def index_to_grid_loc(index)
    x = (index / @size)
    y = (index % @size)
    [x,y]
  end

  def random_board_loc
    x = (0...@size).to_a.sample
    y = (0...@size).to_a.sample
    [x, y]
  end

  def set_grid_loc(loc, value)
    self[*loc] = value
  end

  def render
    @grid.each do |row|
      row_disp = row.map do |card|
        card = card.to_s
        if card.size < 2
          card += " "
        end
        card
      end
      puts row_disp.join(" | ")
    end
    puts "\n"
  end

  def show_bombs
    @bombs.each { |bomb| bomb.reveal }
    render
    sleep(2)
    system "clear"
    @bombs.each { |bomb| bomb.hide }
  end

  def won?
    @grid.flatten.all? { |card| card.is_a?(Bomb) || card.exposed? }
  end

  def reveal(loc)
    self[*loc].reveal
  end

  def hide(cards)
    cards.each { |card| card.hide }
  end
end

class Game
  def initialize(player)
    @player = player
    @size = get_difficulty
    @board = Board.new(@size)
    @turns = 0
    @max_turns = @size * 3
  end

  def get_difficulty
    @player.select_difficulty
  end

  def play
    @board.show_bombs
    turn until @board.won? || @turns > @max_turns
    puts (@board.won? ? "PLAYER WINS!" : "PLAYER LOSES!")
  end

  def get_and_reveal_card
    pos = @player.select_card(@size)
    card = @board[*pos]
    card.reveal
    bomb_check(card)
    @player.receive_match(card)
    @board.render
    card
  end

  def bomb_check(card)
    if card.is_a?(Bomb)
      @turns = @max_turns + 1
      puts "PLAYER STEPPED ON A BOMB!"
    end
  end

  def turn
    @board.render
    card1 = get_and_reveal_card
    return if card1.is_a?(Bomb)
    card2 = get_and_reveal_card
    return if card2.is_a?(Bomb)
    if card1 != card2
      card1.hide
      card2.hide
      puts "NOT A MATCH!"
    else
      puts "MATCH!"
    end
    @turns += 1
    sleep(2)
    system "clear"
  end
end

class Player
  def initialize
    @prev_guess = nil
    @current_guess = nil
    @guesses = {}
    @matches = []
  end

  def valid_selection?(selection, board_size)
    return false if selection.length != 2
    p "okay"
    begin
      selection.each_with_index do |num, idx|
        num_int = num.to_i
        return false if num_int.to_s != num || !num_int.between?(0, board_size - 1)
        # pos[idx] = num_int
      end
    rescue NoMethodError
      return false
    end
    true
  end
  
  def receive_match(card)

  end
end

class Human < Player
  def select_card(board_size)
    begin
      puts "select a card (format: 1,2)"
      selection = gets.chomp.split(",")
      raise ArgumentError if !valid_selection?(selection, board_size)
    rescue
      puts "Invalid card. Try again."
      retry
    end
    p selection
    selection.map! { |loc| loc.to_i }
  end

  def select_difficulty
    begin
      puts "select difficulty (4, 6, 8)"
      diff = gets.chomp.to_i
      raise ArgumentError unless [4, 6, 8].include?(diff)
    rescue
      puts "Invalid selection!"
      retry
    end
    diff
  end
end

class Computer < Player
  attr_reader :board_locs

  def generate_board_locs(size)
    @board_locs = []
    (0...size).each do |x|
      (0...size).each do |y|
        @board_locs << [x, y]
      end
    end
  end

  def random_guess
    guess = @board_locs.sample
    @board_locs.delete(guess)
    guess
  end

  def select_card(board_size)
    selection = nil
    if @prev_guess
      val = @prev_guess.value
      if @guesses[val].size == 2
        selection = @guesses[val].find { |loc| loc != @current_guess }
        @guesses.delete(val)
      else
        selection = random_guess
      end
    elsif match_ready?
      selection = match_ready?[1][0]
    else
      selection = random_guess
    end

    @current_guess = selection
  end

  def match_ready?
    @guesses.find { |k, v| v.size == 2 }
  end

  def receive_match(card)
    @prev_guess = @prev_guess ? nil : card

    val = card.value
    if @guesses[val]
      @guesses[val] << @current_guess unless @guesses[val].include?(@current_guess)
    else
      @guesses[val] = [@current_guess]
    end
  end

  def select_difficulty
    diff = [4, 6, 8].sample
    generate_board_locs(diff)
    diff
  end
end

if __FILE__ == $PROGRAM_NAME
  h = Human.new
  c = Computer.new
  g = Game.new(h)
  g.play
end
