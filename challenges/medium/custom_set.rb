=begin

Create a custom set type.

Sometimes it is necessary to define a custom data structure of some type, like a set. In this exercise you will define your own set type. How it works internally doesn't matter, as long as it behaves like a set of unique elements that can be manipulated in several well defined ways.

In some languages, including Ruby and JavaScript, there is a built-in Set type. For this problem, you're expected to implement your own custom set type. Once you've reached a solution, feel free to play around with using the built-in implementation of Set.

For simplicity, you may assume that all elements of a set must be numbers.

Problem:

Create a class which can act as a custom way to deal with a set of data - numbers in this case. The internal function does not matter so long as it responds to specific method calls and each method manipulates the data in an expected way.

Examples: 

See test cases

Data Structure:

- Array objects

Class: CustomSet
  METHODS:
- `#inititalize(arg = [])` -> Constructor which takes one argument. Arg defaults to empty array.
- `#empty?` -> returns true if the set is empty.
- `#contains?(arg)` -> returns true if the arg passed to method is part of exisisting set, false otherwise.
- `#subset?(other_set)` -> returns true if self is empty set, otherwise, checks if any elements are shared between two sets AND in the SAME ORDER. returns true if so, false otherwise.
- `#disjoint?(other_set)` -> returns true if there are no elements shared between two sets.
- `#eql?` -> returns true if elements in both sets are equal, regardless of the order in which they appear. If multiple elements exists, it does not affect return.
- `#add(element)` -> adds argument to the custom set array at the end. Does NOT ADD if element already exists in the set
- `#intersection(other_set)` -> creates a new custom set object populated by elements present in self and other_set in the order in which they were present in self
- `#difference(other_set)` -> creates a custom set object which is populated by the elements in self which are NOT present in other_set
- `#union(other_set)` -> creates a new custom object which is the result of two custom set objects joined without duplicates, in the order of appearance in each set.

=end


class CustomSet
  attr_accessor :set

  def initialize(set = [])
    @set = set
  end

  def empty?
    @set.empty?
  end

  def contains?(value)
    set.include?(value)
  end

  def subset?(other)
    return true if empty?

    compare_array = other.set.map { |elem| set.count(elem).zero? ? nil : elem }.compact

    compare_array == set
  end

  def disjoint?(other_set)
    return true if empty?

    flag = true
    set.each { |value| flag = false if other_set.set.any?(value) }
    flag
  end

  def eql?(other)
    set.uniq.sort == other.set.uniq.sort
  end

  def add(value)
    set << value unless contains?(value)
    self.class.new(set)
  end

  def ==(other)
    set == other.set
  end

  def intersection(other)
    result = []

    set.each { |val| result << val if other.contains?(val) }

    self.class.new(result.uniq)
  end

  def difference(other)
    result = []

    set.each { |val| result << val unless other.contains?(val) }

    self.class.new(result.uniq)
  end

  def union(other)
    result = []

    return self.class.new(other.set) if empty?

    set.each_with_index do |val, idx|
      result << val
      result << other.set[idx] unless result.include?(other.set[idx])
    end
    self.class.new(result.compact)
  end
end
