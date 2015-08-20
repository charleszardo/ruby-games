class Card
  attr_reader :value
  
  def initialize(value)
    @value = value
    @facing = :down
  end
  
  def hide
    @facing = :down
  end
  
  def reveal
    @facing = :up
    @value
  end
  
  def to_s
    puts @value
  end
  
  def ==(other)
    value == other.value
  end
end