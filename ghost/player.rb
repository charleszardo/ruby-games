# require 'byebug'
require_relative '../player'
require_relative '../computer_player'

class MoveFinder
  def initialize(dict, fragment)
    @dictionary, @fragment = dict, fragment
  end

  def run
    ('a'..'z').each do |letter|
      current_fragments = [@fragment]
      until current_fragments.empty?
        current_fragments = []
      end
    end
  end
end
