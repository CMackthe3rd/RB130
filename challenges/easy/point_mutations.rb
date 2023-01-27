class DNA
  attr_reader :sample

  def initialize(sample)
    @sample = sample
  end

  def hamming_distance(other_sample)
    result = 0
    shortest_sample = sample.size < other_sample.size ? sample : other_sample

    shortest_sample.size.times do |index|
      result += 1 unless sample[index] == other_sample[index]
    end
    result
  end
end