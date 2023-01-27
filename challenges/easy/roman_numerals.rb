class RomanNumeral
  # array.zip.array.to_h chaining to conver all possible number => roman numeral pairings into a hash 

  MODERN_TO_ROMAN = [
    1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000].zip(['I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M']).to_h

  def initialize(number)
    @modern = number
  end

  def to_roman
    roman_numeral = ''
    working_number = @modern

    while working_number.positive?
      if MODERN_TO_ROMAN[working_number] # if the the Hash[key] pairs to an existing value.
        roman_numeral += MODERN_TO_ROMAN[working_number] # append the value to roman_numeral
        return roman_numeral # and explicitly return it.
      end

      roman_numeral += MODERN_TO_ROMAN[get_location(working_number)] # otherwise, get the closest convertible number 
      # and append that to roman_numeral
      working_number -= get_location(working_number) # whilst subtracting said closest number from working_number
      # until the initial if conditional is truthy.
    end
    roman_numeral
  end

  def get_location(number_given) # to use only if the modern number does not have direct roman numeral equivalent
    can_be_converted = MODERN_TO_ROMAN.keys # array of integers which can be converted to roman numerals
    correct_index = (can_be_converted << number_given) # push the number provided to the array of keys
    correct_index = (correct_index.sort.index(number_given)) - 1 # sort array, locate the index of number given and subtract 1 from the index (get next lowest index)
    can_be_converted[correct_index] # the next lowest index which CAN be converted to a roman numeral
    # this will provide the number in the array of keys which matches the keys in the MODERN_TO_ROMAN hash
  end
end