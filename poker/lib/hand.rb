class Hand
  attr_reader :cards
  
  def initialize
    @cards = []
    @hand_types = [:royal_flush,
                   :straight_flush,
                   :four_of_a_kind,
                   :full_house,
                   :flush,
                   :straight,
                   :three_of_a_kind,
                   :two_pair,
                   :one_pair,
                   :high_card]
  end
  
  def add_card(card)
    raise "Too many cards" if @cards.size >= 5
    @cards << card
  end
  
  def remove_card(card)
    p @cards
    p card
    @cards.delete(card)
    p @cards
  end
  
  def reveal
    revelation = []
    @cards.each do |card|
      revelation << [card.suit, card.val]
    end
    p revelation
  end
  
  def determine_hand
    hand = nil
    @hand_types.each_with_index do |type, idx|
      meth = type.to_s + "?"
      result = self.send(meth)
      if result
        hand = {hand: type,
                idx: idx,
                card: result}
        break
      end
    end
  end
  
  def royal_count
    cards.count { |card| card.val >= 10 }
  end
  
  def consecutive?(cards=cards)
    vals = cards.map { |card| card.val }
    vals = vals.sort
    if vals.include?(14) && vals.include?(2)
      vals.pop
      vals.shift(1)
    end
    
    prev = nil
    vals.each do |n|
      return false if prev && n - prev != 1
      prev = n
    end
    highest_card(cards).val
  end
  
  def kinds
    vals = {}
    cards.each do |card|
      val = card.val
      vals[val] = (vals[val] || 0) + 1
    end
    vals
  end
  
  def highest_card(cards=cards)
    high = nil;
    cards.each do |card|
      high = card if !high || card.val > high.val
    end
    high
  end
  
  def n_of_a_kind?(n)
    num = kinds.select { |k, v| kinds[k] == n }
    num.empty? ? false : num.keys[0]
  end
  
  def royal_flush?
    flush? && royal_count >= 5
  end
  
  def straight_flush?
    return consecutive? if flush?
    false
  end
  
  def four_of_a_kind?
    n_of_a_kind?(4)
  end
  
  def full_house?
    return n_of_a_kind?(3) if kinds.values.include?(3) && kinds.values.include?(2)
    false
  end
  
  def flush?
    suits = {}
    cards.each do |card|
      suits[card.suit] = card.suit || true
    end
    suits.keys.size == 1 ? highest_card : false
  end
  
  def straight?
    consecutive?
  end
  
  def three_of_a_kind?
    n_of_a_kind?(3)
  end
  
  def two_pair?
    return false unless kinds.values.count(2) == 2
    
    vals = {}
    cards.each do |card|
      val = card.val
      vals[val] = vals[val] || []
      vals[val] << { card: card, val: val }
    end
    high_card = nil
    high_val = nil
    
    vals.each do |k, v|
      card_obj = v[0]
      if high_val.nil? || card_obj[:val] > high_val
        high_card = card_obj[:card]
        high_val = card_obj[:val]
      end
    end
    high_card
  end
  
  def one_pair?
    n_of_a_kind?(2)
  end
  
  def high_card?
    highest_card
  end
  
  def display
    cards = @cards.map { |card| card.display }
    puts cards.join(", ")
  end
end