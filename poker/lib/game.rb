require_relative 'player'
require_relative 'deck'

class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @deck = Deck.new
    @players = [@player1, @player2]
  end
  
  def play
    deal_hands
  end
  
  def deal_hands
    5.times do
      @players.each do |player|
        card = @deck.deal
        player.receive_card(card)
      end
    end
  end
end