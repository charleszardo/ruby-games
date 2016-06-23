require_relative '../game'

class HangmanGame < Game
  def self.valid_guess?(guess)
    guess.length == 1 && guess.to_s == guess
  end

  def self.secret_setup(word)
    word.split("").map { "_" }
  end

  attr_accessor :secret_word, :secret_length, :secret

  def initialize(player=Hangman::Human.new, dealer=Hangman::Computer.new)
    @player = player
    @dealer = dealer
    setup
  end

  def setup
    @dict = HangmanGame.create_dictionary
    @player.receive_dict(@dict)
    @dealer.receive_dict(@dict)
    @secret_word = get_secret_word
    @secret_display = HangmanGame.secret_setup(@secret_word)
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
      if HangmanGame.valid_guess?(letter) && !already_guessed?(letter)
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