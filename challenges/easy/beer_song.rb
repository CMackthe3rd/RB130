class BeerSong
  def self.lyrics
    verses(99, 0)
  end

  def self.verse(num)
    num1, num2 = num, (num - 1)

    case num1
    when 2 
      "#{num1} bottles of beer on the wall, #{num1} bottles of beer.\n" \
      "Take one down and pass it around, #{num2} bottle of beer on the wall.\n"
    when 1
      "#{num1} bottle of beer on the wall, #{num1} bottle of beer.\n" \
      "Take it down and pass it around, no more bottles of beer on the wall.\n"
    when 0
      "No more bottles of beer on the wall, no more bottles of beer.\n" \
      "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    else
      "#{num1} bottles of beer on the wall, #{num1} bottles of beer.\n" \
      "Take one down and pass it around, #{num2} bottles of beer on the wall.\n"
    end
  end

  def self.verses(*nums)
    song = []
    current_num = nums.max
    until current_num < nums.min
      song << verse(current_num)
      current_num -= 1
    end
    song.join("\n")
  end
end