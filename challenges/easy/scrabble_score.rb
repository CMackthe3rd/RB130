class Scrabble

  SCRABBLE_SCORE = {
    1 => %w[A E I O U L N R S T],
    2 => %w[D G],
    3 => %w[B C M P],
    4 => %w[F H V W Y],
    5 => %w[K],
    8 => %w[J X],
    10 => %w[Q Z]
}.freeze

  def initialize(string)
    @word = string ? string.gsub(/[^a-z]/i, '') : ''
  end

  def score
    final_score = 0
    @word.upcase.chars.each do |letter|
      final_score += score_per_letter(letter)
    end
    final_score
  end

  def self.score(string)
    Scrabble.new(string).score
  end

  private

  def score_per_letter(string)
    score = 0
    SCRABBLE_SCORE.each_key do |value|
      score += value if SCRABBLE_SCORE[value].include?(string)
    end
    score
  end
end

