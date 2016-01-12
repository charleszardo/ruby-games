class Game
  def initialize(player)
    @player = player
    @size = get_difficulty
    @board = Board.new(@size)
    @turns = 0
    @max_turns = @size * 3
  end

  def get_difficulty
    @player.select_difficulty
  end

  def play
    @board.show_bombs
    turn until @board.won? || @turns > @max_turns
    puts (@board.won? ? "PLAYER WINS!" : "PLAYER LOSES!")
  end

  def get_and_reveal_card
    pos = @player.select_card(@size)
    card = @board[*pos]
    card.reveal
    bomb_check(card)
    @player.receive_match(card)
    @board.render
    card
  end

  def bomb_check(card)
    if card.is_a?(Bomb)
      @turns = @max_turns + 1
      puts "PLAYER STEPPED ON A BOMB!"
    end
  end

  def turn
    @board.render
    card1 = get_and_reveal_card
    return if card1.is_a?(Bomb)
    card2 = get_and_reveal_card
    return if card2.is_a?(Bomb)
    if card1 != card2
      card1.hide
      card2.hide
      puts "NOT A MATCH!"
    else
      puts "MATCH!"
    end
    @turns += 1
    sleep(2)
    system "clear"
  end
end