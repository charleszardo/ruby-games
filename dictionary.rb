require 'set'

class Dictionary
  def self.create_dictionary(min_letters, max_letters)
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
  
  def initialize(min_letters, max_letters)
    @min_letters = min_letters
    @max_letters = max_letters
    @dict = Dictionary.create_dictionary(min_letters, max_letters)
  end
  
  def sample
    @dict.to_a.sample
  end
  
  def length
    @dict.length
  end
  
  def include?(word)
    @dict.include?(word)
  end
end