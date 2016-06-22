# require 'byebug'

class Player
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

  def play_turn
    puts "Gimme a letter"
    letter = gets.chomp.downcase
  end

  def receive_dict(dictionary)
    @dictionary = dictionary
  end

  def receive_fragment(fragment)
    @fragment = fragment
  end

  def receive_num_players(num)
    @players = num
  end
end

class Computer < Player
  def play_turn
    letter_mapping = {}
    ("a".."z").each do |letter|
      new_word = @fragment + letter
      matches = (@dictionary.grep /\A#{new_word}/)
      score = 0
      # debugger
      if @dictionary.include?(new_word)
        score = -1000
      else
        matches.each do |match|
          size_diff = match.length - @fragment.length
          score += size_diff % @players.size == 0 ? -1 : 1
        end
      end

      letter_mapping[letter] = score
    end

    letter_mapping.sort_by { |_, v| v }.reverse[0][0]
  end
end

class MoveFinder
  def initialize(dict, fragment)
    @dictionary, @fragment = dict, fragment
  end

  def run
    ('a'..'z').each do |letter|
      current_fragments = [@fragment]
      until current_fragments.empty?
        current_fragments = []
      end
    end
  end
end
