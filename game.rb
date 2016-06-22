class Game
  def self.create_dictionary(min_letters=nil, max_letters=nil)
    dictionary = Set.new
    File.open("./dictionary.txt").each_line do |line|
      l = line.chomp
      dictionary << l if l.length >= 3
    end
    dictionary
  end
end