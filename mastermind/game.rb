module Mastermind
  class Game
    def initialize(player1, player2)
      @player1, @player2 = player1, player2
      @turns = 0
      @max_turns = 10
    end
  
    def play
      correct_code = @player1.create_code

      while @turns < @max_turns
        @turns += 1
        
        guess = @player2.create_code
        guess.display
      
        comparison = guess.compare(correct_code)
        exact, near = comparison[:exact], comparison[:near]
        if exact == 4
          puts "you won in #{@turns} tries!"
          return
        else
          puts "you have #{exact} correct and #{near} near."
        end
      end
      
      puts "10 turns up! you lose!"
    end
    
  end
end