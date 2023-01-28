=begin
Write a program that manages robot factory settings.

When robots come off the factory floor, they have no name. The first time you boot them up, a random name is generated, such as RX837 or BC811.

Every once in a while, we need to reset a robot to its factory settings, which means that their name gets wiped. The next time you ask, it will respond with a new random name.

The names must be random; they should not follow a predictable sequence. Random names means there is a risk of collisions. Your solution should not allow the use of the same name twice.
=end

class Robot
  attr_reader :name

  def initialize
    @name = reset
    add_to_history(name)
  end

  def reset
    test_name = generate_name
    loop do
      break unless history.include?(test_name)

      test_name = generate_name
    end

    add_to_history(test_name)
    @name = test_name
  end

  private

  @@history = []

  def history
    @@history
  end

  def add_to_history(used_name)
    @@history << used_name
  end

  def generate_name
    array_letters = *'A'..'Z'
    array_numbers = *0..9
    working_name = []
    2.times do
      working_name << array_letters.sample
    end

    3.times do
      working_name << array_numbers.sample
    end
    working_name.join
  end
end