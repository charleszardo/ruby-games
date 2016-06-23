require 'set'

class Game
  def self.create_dictionary(min_letters=nil, max_letters=nil)
    dictionary = Set.new
    File.open("./dictionary.txt").each_line do |line|
      valid = true
      word = line.chomp
      len = word.length
      if (min_letters && len < min_letters) || (max_letters && len < max_letters)
        valid = false
      end
      
      dictionary << word if valid
    end
    dictionary
  end
end