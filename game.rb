require 'set'
require_relative 'dictionary'

class Game
  def self.create_dictionary(min_letters=nil, max_letters=nil)
    return Dictionary.new(min_letters, max_letters)
  end
end