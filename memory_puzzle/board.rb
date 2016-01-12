class Board
  def initialize(size=4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    @play_with_bombs = true
    @bombs = []
    populate
  end

  def populate
    max = @size**2 / 2
    values = (1..max).map {|n| [n,n] }.flatten
    values.shuffle.each_with_index do |value, idx|
      card = Card.new(value)
      loc = index_to_grid_loc(idx)
      set_grid_loc(loc, card)
    end

    add_bombs
    nil
  end

  def add_bombs
    return unless @play_with_bombs
    ((@size - 2) / 2).times do
      x, y = random_board_loc
      val = self[x,y].value
      @bombs << self[x, y] = Bomb.new
      x, y = find_value_on_grid(val)
      @bombs << self[x, y] = Bomb.new
    end
  end

  def find_value_on_grid(val)
    (0...@size).each do |x|
      (0...@size).each do |y|
        return [x,y] if self[x,y].value == val
      end
    end
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, value)
    @grid[x][y] = value
  end

  def index_to_grid_loc(index)
    x = (index / @size)
    y = (index % @size)
    [x,y]
  end

  def random_board_loc
    x = (0...@size).to_a.sample
    y = (0...@size).to_a.sample
    [x, y]
  end

  def set_grid_loc(loc, value)
    self[*loc] = value
  end

  def render
    @grid.each do |row|
      row_disp = row.map do |card|
        card = card.to_s
        if card.size < 2
          card += " "
        end
        card
      end
      puts row_disp.join(" | ")
    end
    puts "\n"
  end

  def show_bombs
    @bombs.each { |bomb| bomb.reveal }
    render
    sleep(2)
    system "clear"
    @bombs.each { |bomb| bomb.hide }
  end

  def won?
    @grid.flatten.all? { |card| card.is_a?(Bomb) || card.exposed? }
  end

  def reveal(loc)
    self[*loc].reveal
  end

  def hide(cards)
    cards.each { |card| card.hide }
  end
end