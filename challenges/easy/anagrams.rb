class Anagram
  def initialize(string)
    @word = string.downcase
  end

  def match(array_other_strings)
    array_other_strings.select { |str| is_valid_anagram?(str) }
  end

  def is_valid_anagram?(other_string)
    other_string.downcase.chars.sort == @word.chars.sort && other_string.downcase != @word
  end
end
