require_relative 'game'
require_relative 'player'

class Human < HangmanPlayer
  def pick_secret_word
    gets.chomp
  end

  def guess_letter
    gets.chomp
  end
end

class Computer < Player
  def initialize
    set_letters
  end

  def set_letters
    @letters = {}
    %w(a b c d e f g h i j k l m n o p q r s t u v w x y z).each do |letter|
      @letters[letter] = true
    end
  end

  def pick_secret_word
    @dict.sample
  end

  def receive_secret_length(len)
    @secret_length = len
    reduce_dict_size
  end

  def update_dict(guess, locs)
    new_dict = []
    @dict.each do |word|
      next if locs.empty? && word.include?(guess)
      next unless locs.all? {|idx| word[idx] == guess}
      new_dict << word
    end
    @dict = new_dict
  end

  def reduce_dict_size
    @dict.select! {|word| word.length == @secret_length}
  end

  def count_letters
    count = {}
    @dict.each do |word|
      word.split("").each do |char|
        if @letters.include?(char)
          count[char] = (count[char] || 0) + 1
        end
      end
    end
    count
  end

  def receive_guess_response(guess, locs)
    @letters.delete(guess)
    update_dict(guess, locs)
  end

  def guess_letter
    count_letters.max_by{|k,v| v}[0]
  end
end

if $PROGRAM_NAME == "arcade.rb"
  h = Human.new
  c = Computer.new
  g = HangmanGame.new(h,c)
  #g = Hangman::Game.new(c,h)
  g.play
end