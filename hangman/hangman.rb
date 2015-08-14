module Hangman
  class Game
    attr_accessor :secret_word, :secret_length, :secret
    
    def initialize(player=Hangman::Human.new, dealer=Hangman::Computer.new)
      @player = player
      @dealer = dealer
      @dict = Game.create_dictionary
      @player.receive_dict(@dict)
      @dealer.receive_dict(@dict)
      
      set_secret_word
      @secret_word = Game.secret_setup(@secret)
      @secret_length = @secret_word.length
      @player.receive_secret_length(@secret_length)
    end
    
    def set_secret_word
      loop do
        puts "give me a secret word"
        word = @dealer.pick_secret_word.downcase
        if valid_word?(word)
          @secret = word
          break
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
      
      puts "you won in #{guesses} guesses. the secret word was #{@secret}."
    end
    
    def play_turn
      display
      guess
    end
    
    def guess
      loop do
        letter = @player.guess_letter
        if Game.valid_guess?(letter)
          handle_guess(letter)
          break
        else
          puts "invalid guess!"
        end
      end
    end
    
    def handle_guess(guess)
      @secret_word.each do |k, v|
        v[:display] = true if v[:char] == guess
      end
    end
    
    def display
      word = []
      @secret_length.times { word << "_"}
      @secret_word.each do |k, v|
        if v[:display]
          word[k] = v[:char]
        end
      end
      puts word.join(" ")
      nil
    end
    
    def solved?
      @secret_word.all? do |k, v|
        v[:display] == true
      end
    end
    
    def self.valid_guess?(guess)
      guess.length == 1 && guess.to_s == guess
    end
    
    def self.secret_setup(word)
      word_hash = {}
      word.split("").each_with_index do |letter, idx|
        word_hash[idx] = {:char => letter, :display => false}
      end
      word_hash
    end
    
    def self.create_dictionary
      dictionary = []
      File.open("./dictionary.txt").each_line do |line|
        dictionary << line.chomp
      end
      dictionary
    end
  end
  
  
  class Player
    attr_reader :dict
    
    def initialize
    end
    
    def guess_letter
    end
    
    def create_word
    end
    
    def receive_dict(dict)
      @dict = dict
    end
    
    def receive_secret_length(len)
      @secret_len = len
    end
  end
  
  class Human < Player
    def initialize
      
    end
    
    def pick_secret_word
      gets.chomp
    end
    
    def receive_secret_length(len)
      @secret_length = len
    end
    
    def guess_letter
      puts "guess a letter"
      gets.chomp
    end
  end
  
  class Computer < Player
    def initialize
      @guessed_letters = {}
    end
    
    def pick_secret_word
      @dict.sample
    end
    
    def receive_secret_length(len)
      @secret_length = len
    end
    
    def guess_letter
      puts "guess a letter"
      gets.chomp
    end
  end
end

if $PROGRAM_NAME == __FILE__
  h = Hangman::Human.new
  c = Hangman::Computer.new
  g = Hangman::Game.new(h,c)
  #g = Hangman::Game.new(c,h)
  g.play
end