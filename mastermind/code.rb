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