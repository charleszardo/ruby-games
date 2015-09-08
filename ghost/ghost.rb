require 'set'
require_relative 'player'

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
    puts "GAME OVER! #{@players[0]} wins!"
  end

  private

  def play_round
    turn until round_over?
    show_scores
    remove_players
    send_num_players
    reset
  end

  def show_scores
    @scores.each { |player, score| puts "#{player}: #{score_to_ghost(score)}" }
    puts "\n"
  end

  def score_to_ghost(score)
    score >= 5 ? "LOST" : GHOST[0...score].join.upcase
  end

  def setup
    @current_player = @players[0]
    @previous_player = nil
    @scores = {}
    @players.each { |player| @scores[player] = 0 }
    reset
    send_players_dictionary
    send_players_fragment
    send_num_players
  end

  def send_players_dictionary
    @players.each { |player| player.receive_dict(@dictionary) }
  end

  def send_players_fragment
    @players.each { |player| player.receive_fragment(@fragment) }
  end

  def send_num_players
    @players.each { |player| player.receive_num_players(@players.size) }
  end

  def remove_players
    @players.select! do |player|
      if @scores[player] < 5
        true
      else
        puts "#{player} loses! \n\n"
        false
      end
    end
  end

  def reset
    @fragment = ""
    @dictionary = Game.create_dictionary
  end

  def update_dict
    @dictionary = @dictionary.grep /#{@fragment}/
    send_players_dictionary
  end

  def turn
    puts "#{@current_player}'s turn."
    puts "Word: #{@fragment} \n\n"
    @fragment += get_letter
    puts "\n"
    update_dict
    send_players_fragment
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
    @players.size == 1
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


if $PROGRAM_NAME == __FILE__
  p1 = Player.new("Player 1")
  p2 = Player.new("Player 2")
  p3 = Computer.new("KOMPUTER")
  g = Game.new(p1, p2, p3).play
end
