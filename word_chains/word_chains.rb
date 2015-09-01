require 'set'

class WordChainer
  def self.create_dictionary(file)
    Set.new File.open(file).map { |l| l.chomp }
  end

  def initialize(dictionary_file)
    @dictionary = WordChainer.create_dictionary(dictionary_file)
  end

  def run(source, target)
    @current_words = Set.new [source]
    @all_seen_words = { source => nil }

    until @current_words.empty?
      new_current_words = Set.new explore_current_words
      break if new_current_words.include?(target)
      @current_words = new_current_words
    end

    build_path(target)
  end

  def build_path(target)
    target == nil ? [] : build_path(@all_seen_words[target]) << target
  end

  def explore_current_words
    @current_words.map { |curr_word| find_new_adjacent_words(curr_word) }.flatten
  end

  def find_new_adjacent_words(base_word)
    adjacent_words(base_word).select do |adj_word|
      @all_seen_words.has_key?(adj_word) ? false : @all_seen_words[adj_word] = base_word
    end.flatten
  end

  def adjacent_words(word)
    @dictionary.select { |dict_word| adjacent_words?(word, dict_word) }
  end

  def adjacent_words?(word1, word2)
    same_length?(word1, word2) && off_by_one?(word1, word2)
  end

  def off_by_one?(word1, word2)
    get_diff(word1, word2) == 1
  end

  def same_length?(word1, word2)
    word1.length == word2.length
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
  p w.run("market", "junker")
end
