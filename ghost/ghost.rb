require 'set'

class Game
  attr_reader :current_player, :previous_player, :players, :dictionary

  GHOST = %w(g h o s t)

  def self.create_dictionary
    dictionary = Set.new
    File.open("./dictionary.txt").each_line do |line|
      l = line.chomp
      dictionary << l if l.length >= 3
    end
    dictionary
  end

  def initialize(*players)
    @players = players
    setup
  end

  def play
    play_round until game_over?
    puts "GAME OVER! #{@previous_player.name} loses!"
  end

  private

  def play_round
    turn until round_over?
    show_scores
    reset
  end

  def show_scores
    @scores.each do |player, score|
      puts "#{player}: #{GHOST[0...score].join.upcase}"
    end
  end

  def setup
    @current_player = @players[0]
    @previous_player = nil
    @scores = {}
    @players.each { |player| @scores[player] = 0}
    reset
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
    @fragment += get_letter
    update_dict
    next_player!
  end

  def get_letter
    loop do
      next_letter = @current_player.play_turn
      return next_letter.downcase if valid_play?(next_letter)
    end
  end

  def round_over?
    if @fragment.size > 3 && @dictionary.include?(@fragment)
      @scores[@previous_player] += 1
      return true
    end
    false
  end

  def game_over?
    @players.any? { |p| @scores[p] >= 5 }
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
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
    reset_score
  end

  def play_turn
    puts "Gimme a letter"
    letter = gets.chomp.downcase
  end
end

if $PROGRAM_NAME == __FILE__
  p1 = Player.new("Player 1")
  p2 = Player.new("Player 2")
  p3 = Player.new("Player 3")
  g = Game.new(p1, p2, p3)
  g.play
end
