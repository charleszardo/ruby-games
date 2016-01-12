class Player
  def initialize
    @prev_guess, @current_guess, @guesses, @matches = nil, nil, {}, []
  end
  
  def valid_coord?(coord, board_size)
    coord_int = coord.to_i
    coord_int.to_s == coord && coord_int.between?(0, board_size - 1)
  end

  def valid_selection?(selection, board_size)
    begin
      return false if selection.length != 2 || selection.any? { |coord| !valid_coord?(coord, board_size)}
    rescue NoMethodError
      return false
    end
    true
  end
  
  def receive_match(card)
    # don't erase this
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