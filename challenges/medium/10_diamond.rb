class Diamond
  def self.make_diamond(letter)
    working_array = ('B'..letter).to_a
    width = (working_array.size * 2) + 1
    result = 'A' << "\n"
    return result if letter == 'A'

    result = 'A'.center(width) << "\n"

    working_array.each_with_index do |ltr, idx|
      result << (ltr + ' ' * ((idx * 2) + 1) + ltr).center(width) << "\n"
    end

    reversed_string = result.split("\n").reverse
    reversed_string.shift
    reversed_string.each do |grp|
      result << grp << "\n"
    end
    result
  end
end

