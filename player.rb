class Player
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

  def select_letter
    letter = gets.chomp.downcase
  end

  def receive_dict(dictionary)
    @dictionary = dictionary
  end

  def receive_fragment(fragment)
    @fragment = fragment
  end

  def receive_num_players(num)
    @players = num
  end
end