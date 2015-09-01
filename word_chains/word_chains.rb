require 'set'

class WordChainer
  def self.create_dictionary(dictionary_file)
    dictionary = Set.new
    File.open(dictionary_file).each_line do |line|
      l = line.chomp
      dictionary << l if l.length >= 3
    end
    dictionary
  end

  def initialize(dictionary_file)
    @dictionary = WordChainer.create_dictionary(dictionary_file)
  end

  def run(source, target)
    @current_words = Set.new [source]
    @all_seen_words = Set.new [source]

    until @current_words.empty?
      new_current_words = Set.new explore_current_words
      @current_words = new_current_words
    end
  end

  def explore_current_words
    @current_words.map { |curr_word| find_new_adjacent_words(curr_word) }.flatten
  end

  def find_new_adjacent_words(base_word)
    adjacent_words(base_word).select do |adj_word|
      if @all_seen_words.include?(adj_word)
        false
      else
        @all_seen_words << adj_word
        true
      end
    end.flatten
  end

  def adjacent_words(word)
    @dictionary.select { |dict_word| adjacent_words?(word, dict_word) }
  end

  def adjacent_words?(word1, word2)
    word1.length == word2.length &&
    get_diff(word1, word2) == 1
  end

  def get_diff(word1, word2)
    diffs = 0
    word1 = word1.split("")
    word2 = word2.split("")
    word1.each_index { |idx| diffs += 1 if word1[idx] != word2[idx] }
    diffs
  end
end

if __FILE__ == $PROGRAM_NAME
  w = WordChainer.new('./dictionary.txt')
  w.run("dog", "doc")
end
