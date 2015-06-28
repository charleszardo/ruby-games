class Game
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @turns = 0
  end
  
  def compare(seq1, seq2)
    exact, near = 0, 0
    test1, test2 = seq1.seq.dup, seq2.seq.dup
    test1_hash = {}
    
    test1.each_index do |idx|
      color1, color2 = test1[idx], test2[idx]
      if color1 == color2
        exact += 1
        test1[idx] = nil
        test2[idx] = nil
      else
        test1_hash[color1] = (test1_hash[color1] || 0) + 1
      end
    end
    
    test2.each do |color|
      if test1_hash[color]
        near += 1
        test1_hash[color] > 1 ? test1_hash[color] -= 1 : test1_hash.delete(color)
      end
    end
    
    {:exact => exact, :near => near}
  end
  
  def play
    correct_code = @player1.create_code
    correct_code.display
    30.times do
      puts "XXXXXXXXXXX"
    end
    while true
      @turns += 1
      guess = @player2.create_code
      guess.display
      
      comparison = self.compare(correct_code, guess)
      exact, near = comparison[:exact], comparison[:near]
      if exact == 4
        puts "you won in #{@turns} tries!"
        break
      elsif @turns >= 10
        puts "10 turns up! you lose!"
        break
      else
        puts "you have #{exact} correct and #{near} near."
      end
    end
  end
end