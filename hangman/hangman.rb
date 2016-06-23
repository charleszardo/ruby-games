class Game
  def self.valid_guess?(guess)
    guess.length == 1 && guess.to_s == guess
  end

  def self.secret_setup(word)
    word.split("").map { "_" }
  end

  def self.create_dictionary
    File.open("./dictionary.txt").map(&:chomp)
  end

  attr_accessor :secret_word, :secret_length, :secret

  def initialize(player=Hangman::Human.new, dealer=Hangman::Computer.new)
    @player = player
    @dealer = dealer
    setup
  end

  def setup
    @dict = Game.create_dictionary
    p @dict.length
    @player.receive_dict(@dict)
    @dealer.receive_dict(@dict)
    @secret_word = get_secret_word
    @secret_display = Game.secret_setup(@secret_word)
    @secret_length = @secret_word.length
    @player.receive_secret_length(@secret_length)
    @guessed_letters = {}
  end

  def get_secret_word
    loop do
      puts "give me a secret word"
      word = @dealer.pick_secret_word.downcase
      if valid_word?(word)
        return word
      else
        puts "invalid secret word!"
      end
    end
  end

  def valid_word?(word)
    @dict.include?(word)
  end

  def play
    guesses = 0
    until solved?
      play_turn
      guesses += 1
    end

    puts "you won in #{guesses} guesses. the secret word was #{@secret_word}."
  end

  private

  def play_turn
    display
    guess
  end

  def guess
    puts "guess a letter"
    loop do
      letter = @player.guess_letter
      if Game.valid_guess?(letter) && !already_guessed?(letter)
        handle_guess(letter)
        break
      else
        puts "invalid guess!"
      end
    end
  end

  def handle_guess(guess)
    @guessed_letters[guess] = true
    locs = parse_secret_word(guess)

    @player.receive_guess_response(guess, locs)
  end

  def parse_secret_word(guess)
    locs = []

    @secret_word.split("").each_with_index do |letter, idx|
      if guess == letter
        @secret_display[idx] = letter
        locs << idx
      end
    end
    locs
  end

  def already_guessed?(guess)
    if @guessed_letters.include?(guess)
      puts "you already guessed that letter!"
      return true
    end
    false
  end

  def display
    puts @secret_display.join(" ")
  end

  def solved?
    @secret_display.none? { |letter| letter == "_" }
  end
end

class Player
  attr_reader :dict

  def initialize
  end

  def receive_dict(dict)
    @dict = dict
  end

  def receive_secret_length(len)
    @secret_len = len
  end

  def receive_guess_response(guess, locs)
  end
end

class Human < Player
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
  g = Game.new(h,c)
  #g = Hangman::Game.new(c,h)
  g.play
end