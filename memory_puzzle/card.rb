class Card
  attr_reader :value

  def initialize(value=nil)
    @value = value
    @facing = :down
  end

  def exposed?
    @facing == :up
  end

  def hide
    @facing = :down
  end

  def reveal
    @facing = :up
    @value
  end

  def to_s
    exposed? ? @value.to_s : "X"
  end

  def ==(other)
    value == other.value
  end
end

class Bomb < Card
  def to_s
    exposed? ? "B" : "X"
  end
end