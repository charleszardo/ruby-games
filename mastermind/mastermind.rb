require 'colorize'

class String
  def orange
    self.light_red
  end
  
  def purple
    self.magenta
  end
end

class Code
  attr_reader :seq
  COLORS = [:red, :green, :blue, :yellow, :orange, :purple]
  
  def initialize(seq = Code.random)
    @seq = seq
  end
  
  def display
    puts @seq.map { |color| color.to_s.send(color)}.join(" ")
  end
  
  def self.random
    code = []
    4.times { code << COLORS.sample }
    code
  end
  
  def self.seq_check
    #todo
  end
end

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
    while true
      @turns += 1
      guess = @player2.create_code
      guess.display
      if guess == correct_code
        puts "you won in #{@turns} tries!"
        break
      elsif @turns >= 10
        puts "10 turns up! you lose!"
      else
        comparison = self.compare(correct_code, guess)
        exact, near = comparison[:exact], comparison[:near]
        puts "you have #{exact} correct and #{near} near."
      end
    end
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
    Code.new(parse_code(gets.chomp.upcase))
  end
  
  def parse_code(code)
    code.split("").map do |color|
      CODE_CONVERTER[color]
    end
  end
end

class Computer < Player
  def create_code
    Code.new
  end
end

if $PROGRAM_NAME == __FILE__
  p2 = Human.new
  p1 = Computer.new

  g = Game.new(p1, p2)
  g.play
  # c1 = Code.new
  # c1.display
end


