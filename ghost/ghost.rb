require 'set'

class Game
  attr_reader :current_player, :previous_player, :players, :dictionary

  def initialize(*players)
    @players = players
    @current_player = @players[0]
    @previous_player = nil
    reset
  end

  def play
    loop do
      play_round
      break if game_over?
    end
    puts "GAME OVER! #{@previous_player.name} loses!"
  end

  def play_round
    loop do
      turn
      break if round_over?
    end
    show_scores
    reset
  end

  def show_scores
    @players.each { |player| player.show_score }
  end

  def reset
    @fragment = ""
    @dictionary = Game.create_dictionary
  end

  def update_dict
    @dictionary = @dictionary.grep /#{@fragment}/
  end

  def turn
    puts "#{@current_player.name}'s turn."
    puts "Word: #{@fragment}"
    next_letter = nil
    loop do
      next_letter = @current_player.play_turn
      break if valid_play?(next_letter)
    end
    @fragment += next_letter.downcase
    update_dict
    next_player!
  end

  def round_over?
    if @fragment.size > 3 && @dictionary.include?(@fragment)
      @previous_player.add_letter
      return true
    end
    false
  end

  def game_over?
    @players.any? { |p| p.lost? }
  end

  def valid_play?(letter)
    return false unless letter.is_a?(String) && letter.size == 1
    temp_word = @fragment + letter.downcase
    !(@dictionary.grep /#{temp_word}/).empty?
  end

  def next_player!
    @previous_player = @current_player
    current_idx = @players.find_index(@current_player)
    next_idx = (current_idx + 1) % @players.size
    next_player = @players[next_idx]
    @current_player = next_player
  end

  def self.create_dictionary
    dictionary = Set.new
    File.open("./dictionary.txt").each_line do |line|
      l = line.chomp
      dictionary << l if l.length >= 3
    end
    dictionary
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
    reset_score
  end

  def reset_score
    @ghost = %w(g h o s t)
  end

  def show_score
    letters = 5 - @ghost.size
    puts "#{@name}: #{%w(G H O S T)[0...letters].join("")}"
  end

  def play_turn
    puts "Gimme a letter"
    letter = gets.chomp.downcase
  end

  def add_letter
    @ghost.shift
  end

  def lost?
    @ghost.empty?
  end
end
if $PROGRAM_NAME == __FILE__
  p1 = Player.new("Player 1")
  p2 = Player.new("Player 2")
  p3 = Player.new("Player 3")
  g = Game.new(p1, p2, p3)
  g.play
end
