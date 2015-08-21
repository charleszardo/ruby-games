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
    @facing == :up ? @value.to_s : "X"
  end
  
  def ==(other)
    value == other.value
  end
end

class Board
  def initialize(size=4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
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
    nil
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
  
  def won?
    @grid.flatten.all? { |card| card.exposed? }
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
  end
  
  def get_difficulty
    @player.select_difficulty
  end
  
  def play
    turn until @board.won? || @turns > 10
    puts (@board.won? ? "YOU WON!" : "YOU LOST!")
  end
  
  def get_and_reveal_card
    pos = @player.select_card(@size)
    card = @board[*pos]
    card.reveal
    card
  end
  
  def turn
    @board.render
    card1 = get_and_reveal_card
    @player.receive_match(card1)
    @board.render
    card2 = get_and_reveal_card
    @player.receive_match(card2)
    @board.render
    if card1 != card2
      card1.hide
      card2.hide
      puts "NOT A MATCH!"
    else
      puts "MATCH!"
    end
    @turns += 1
    sleep(5)
    system "clear"
  end
end

class Player
  def initialize
    @prev_guess = nil
    @current_guess = nil
    @guesses = {}
  end
  
  def valid_selection?(selection, board_size)
    pos = selection.split(",")
    return false if pos.length != 2
    begin
      pos.each_with_index do |num, idx|
        num_int = num.to_i
        return false if num_int.to_s != num || !num_int.between?(0, board_size - 1)
        pos[idx] = num_int
      end
    rescue NoMethodError
      return false
    end
    pos
  end
  
  def receive_match(card)
    
  end
end

class Human < Player
  def select_card(board_size)
    puts "select a card (format: 1,2)"
    selection = nil
    loop do
      selection = gets.chomp
      pos = valid_selection?(selection, board_size)
      if pos
        selection = pos
        break
      end
      puts "invalid card. try again."
    end
    selection
  end
  
  def select_difficulty
    loop do
      puts "select difficulty (4, 6, 8)"
      begin
        diff = gets.chomp.to_i
        return diff if [4, 6, 8].include?(diff)
      rescue
      end
    end
  end
end

class Computer < Player
  
  def select_card(board_size)
    selection = nil
    loop do
      selection = Array.new(2) { (0...board_size).to_a.sample }
      if @prev_guess
        unless @prev_guess == selection
          @prev_guess = nil
          break
        end
      else
        @prev_guess = selection
        break
      end
    end
    
    @current_guess = selection
  end
  
  def receive_match(card)
    val = card.value
    if @guesses[val]
      @guesses[val][:pos] << @current_guess
    else
      @guesses[val] = { :pos => [@current_guess], :matched => false }
    end
    p @guesses
  end
  
  def select_difficulty
    [4, 6, 8].sample
  end
end

if __FILE__ == $PROGRAM_NAME
  h = Human.new
  c = Computer.new
  g = Game.new(c)
  g.play
end