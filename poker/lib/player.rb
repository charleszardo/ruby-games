require_relative 'hand'

class Player
  def initialize
    @hand = Hand.new
    @coins = 0
    @actions = {
      "B" => :bet,
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
      []
    else
      raise "invalid response"
    end
  rescue
    retry
  end
  
  def handle_discard
    puts "which card(s) would you like to discard?  num separated by comma. no more than 3!"
    selection = gets.chomp.split(",").map(&:to_i)
    new_hand = []
    @hand.each_with_index do |card, idx|
      idx += 1
      new_hand << card unless selection.include?(idx)
    end
    new_hand
  rescue
    puts "an error occurred due to response.  try again, chump."
    retry
  end
  
  def receive_coins(num)
    @coins += num
  end
  
  def perform_action
    puts "bet (B), fold (F), see current bet (S), raise (R)"
    action = gets.chomp.upcase
    raise "invalid action" if !valid_action?(action)
    actions[action]
  rescue
    retry
  end
  
  def valid_action?(action)
    @actions.keys.include?(action)
  end
end