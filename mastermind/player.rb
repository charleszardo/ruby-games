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