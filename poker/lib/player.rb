require_relative 'hand'

class Player
  attr_reader :actions
  
  def initialize
    @hand = Hand.new
    @coins = 0
    @actions = {
      "F" => :fold,
      "S" => :see,
      "R" => :raise
    }
  end
  
  def receive_card(card)
    @hand.add_card(card)
  end
  
  def discard
    puts "would you like to discard any cards? (Y/N)"
    answer = gets.chomp.upcase
    if answer == "Y"
      handle_discard
    elsif answer == "N"
      0
    else
      raise "invalid response"
    end
  rescue
    retry
  end
  
  def handle_discard
    puts "which card(s) would you like to discard?  num separated by comma. no more than 3!"
    selection = gets.chomp.split(",").map(&:to_i)
    p selection
    @hand.cards.each_with_index do |card, _idx|
      idx = _idx + 1
      p @hand.size
      if selection.include?(idx)
        @hand.remove_card(card)
      end
      p @hand.size
    end
    
    selection.size
  rescue
    puts "an error occurred due to response.  try again, chump."
    retry
  end
  
  def receive_coins(num)
    @coins += num
  end
  
  def perform_action(bet=0)
    puts "fold (F), see current bet (S), raise (R)"
    action = gets.chomp.upcase
    raise "invalid action" if !valid_action?(action)
    action = actions[action]
    raise "not enough coin!"  if (action == :see || action == :raise) && @coins < bet
    action
  rescue
    puts "ERROR"
    retry
  end
  
  def valid_action?(action)
    @actions.keys.include?(action)
  end
  
  def pay(amount)
    #holder
    1
  end
  
  def display_hand
    @hand.display
  end
end