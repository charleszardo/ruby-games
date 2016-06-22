class ComputerPlayer < Player
  def select_letter
    letter_mapping = {}
    ("a".."z").each do |letter|
      new_word = @fragment + letter
      matches = (@dictionary.grep /\A#{new_word}/)
      score = 0
      # debugger
      if @dictionary.include?(new_word)
        score = -1000
      else
        matches.each do |match|
          size_diff = match.length - @fragment.length
          score += size_diff % @players.size == 0 ? -1 : 1
        end
      end

      letter_mapping[letter] = score
    end

    letter_mapping.sort_by { |_, v| v }.reverse[0][0]
  end
end