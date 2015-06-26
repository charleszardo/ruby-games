class Code
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

c = Code.new
p c