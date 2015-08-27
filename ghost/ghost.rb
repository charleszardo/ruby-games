require 'set'

class Game
  def initialize(*players)
    @players = players
    @fragment = ""
    @dictionary = Game.create_dictionary
  end

  def self.create_dictionary
    dictionary = Set.new
    File.open("./dictionary.txt").each_line do |line|
      dictionary << line.chomp
    end
    dictionary
  end
end

if $PROGRAM_NAME == __FILE__
  g = Game.new(1,2,3,4,5)
end
