require_relative '../player'

class HangmanPlayer < Player
  attr_reader :dict

  def initialize
  end

  def receive_secret_length(len)
    @secret_len = len
  end

  def receive_guess_response(guess, locs)
  end
end