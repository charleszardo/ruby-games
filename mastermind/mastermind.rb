class Code
  attr_reader :seq
  COLORS = [:red, :green, :blue, :yellow, :orange, :purple]
  
  def initialize(seq = Code.random)
    @seq = seq
  end
  
  def self.random
    code = []
    4.times { code << COLORS.sample }
    code
  end
  
  def self.seq_check
    
  end
end

class Game
  def initialize(seq1, seq2)
    @seq1, @seq2 = seq1, seq2
    @turns = 0
  end
  
  def compare(seq1=@seq1, seq2=@seq2)
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
    correct_code = player1.create_code
    
  end
end

class Player
  def create_code
  end
end

class Human < Player
  CODE_CONVERTER = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }
  
  def create_code
    puts "give me a code! (format: 'RGYB')"
    code = gets.chomp
  end
  
  def parse_code
    
  end
end

class Computer < Player
  
end



c1 = Code.new
c2 = Code.new

g = Game.new(c1, c2)
