module Hangman
  class Game
    attr_accessor :secret_word, :secret_length, :secret
    
    def initialize(player=Hangman::Human.new, dealer=Hangman::Computer.new)
      @player = player
      @dealer = dealer
      @dictionary = Game.create_dictionary
      @player.receive_dict(@dictionary)
      word = @dictionary.sample
      @secret = word
      @secret_word = Game.secret_setup(word)
      @secret_length = secret_word.length
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
      
      guess_okay = false
      until guess_okay
        guess = @player.guess_letter
        if Game.valid_guess?(guess)
          guess_okay = true 
        else
          puts "invalid guess!"
        end
      end
      
      handle_guess(guess)
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
    
    def guess_letter
      puts "guess a letter"
      gets.chomp
    end
  end
  
  class Computer < Player
    
    def initialize
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
  g = Hangman::Game.new(c,h)
  g.play
end