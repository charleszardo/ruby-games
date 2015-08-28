require 'set'

class Game
  attr_reader :current_player, :previous_player, :players, :dictionary

  def initialize(*players)
    @players = players
    @current_player = @players[0]
    @previous_player = nil
    @fragment = ""
    @game_over = false
    @round_over = false
    @dictionary = Game.create_dictionary
  end

  def play
    until @game_over
      play_round

    end
  end

  def play_round
    until @round_over
      turn
    end
  end

  def update_dict
  end

  def turn
    next_letter = nil
    loop do
      next_letter = @current_player.play_turn
      break if valid_play?(temp_frag)
    end
    @fragment += next_letter.downcase
  end

  def get_letter
    
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
  def initialize
  end
end
if $PROGRAM_NAME == __FILE__
  g = Game.new(1,2,3,4,5)
end
