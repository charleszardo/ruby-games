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
    test1.each_index do |idx|
      if test1[idx] == test2[idx]
        exact += 1
        test1[idx] = nil
        test2[idx] = nil
      end
    end
    p test1
    p test2
    test1.select! {|color| !color.nil? }
    test2.select! {|color| !color.nil?}
    p test1
    p test2
    
  end
end

c1 = Code.new
c2 = Code.new
p c1
p c2

g = Game.new(c1, c2)
g.compare
