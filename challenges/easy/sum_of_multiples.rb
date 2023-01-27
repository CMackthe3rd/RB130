=begin
Write a program that, given a natural number and a set of one or more other numbers, can find the sum of all the multiples of the numbers in the set that are less than the first number. If the set of numbers is not given, use a default set of 3 and 5.

For instance, if we list all the natural numbers up to, but not including, 20 that are multiples of either 3 or 5, we get 3, 5, 6, 9, 10, 12, 15, and 18. The sum of these multiples is 78.
=end

class SumOfMultiples
  def initialize(*num)
    raise ArgumentError, 'Wrong Input Type' if !num.any?(Integer) unless num.empty?

    @set = num.empty? ? [3, 5] : num
  end

  def to(max_num)
    results = []
    @set.each do |number|
      1.upto(max_num - 1).each do |current_number|
        results << current_number if (current_number % number).zero?
      end
    end
    results.uniq.sum
  end

  def self.to(number)
    SumOfMultiples.new.to(number)
  end
end