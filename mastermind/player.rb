class Player
  def create_code
  end
end

class Human < Player
  def create_code
    guess = nil
    until guess
      puts "give me a code! (format: 'RGYB')"
      guess = Code.parse_code(gets.chomp.upcase)
      puts "invalid code!" if !guess
    end
    guess
  end
end

class Computer < Player
  def create_code
    Code.random
  end
end