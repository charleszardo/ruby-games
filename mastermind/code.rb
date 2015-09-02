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
  CODE_CONVERTER = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }

  def self.parse_code(code)
    return nil if !Code.valid_code?(code)
    parsed_code = code.split("").map do |color|
      CODE_CONVERTER[color]
    end
    Code.new(parsed_code)
  end

  def self.valid_code?(code)
    code = code.split("")
    if code.length != 4
      return false
    elsif code.all? {|color| CODE_CONVERTER.keys.include?(color)}
      return true
    else
      return false
    end
  end

  def self.random
    code = []
    4.times { code << CODE_CONVERTER.values.sample }
    Code.new(code)
  end

  def initialize(seq)
    @seq = seq
  end

  def display
    puts @seq.map { |color| color.to_s.send(color)}.join(" ")
  end

  def [](i)
    @seq[i]
  end

  def compare(seq2)
    exact, near = 0, 0
    test1, test2 = self.seq.dup, seq2.seq.dup
    test1_hash = {}

    test1.each_index do |idx|
      color1, color2 = test1[idx], test2[idx]
      if color1 == color2
        exact += 1
        test1[idx], test2[idx] = nil, nil
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

  protected
  attr_reader :seq
end
