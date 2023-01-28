require 'date'

=begin
Meetups are a great way to meet people who share a common interest. Typically, meetups happen monthly on the same day of the week. For example, a meetup's meeting may be set as:

    The first Monday of January 2021
    The third Tuesday of December 2020
    The teenth wednesday of December 2020
    The last Thursday of January 2021

In this program, we'll construct objects that represent a meetup date. Each object takes a month number (1-12) and a year (e.g., 2021). Your object should be able to determine the exact date of the meeting in the specified month and year. For instance, if you ask for the 2nd Wednesday of May 2021, the object should be able to determine that the meetup for that month will occur on the 12th of May, 2021.

The descriptors that may be given are strings: 'first', 'second', 'third', 'fourth', 'fifth', 'last', and 'teenth'. The case of the strings is not important; that is, 'first' and 'fIrSt' are equivalent. Note that "teenth" is a made up word. There was a meetup whose members realised that there are exactly 7 days that end in '-teenth'. Therefore, it's guaranteed that each day of the week (Monday, Tuesday, ...) will have exactly one date that is the "teenth" of that day in every month. That is, every month has exactly one "teenth" Monday, one "teenth" Tuesday, etc. The fifth day of the month may not happen every month, but some meetup groups like that irregularity.

The days of the week are given by the strings 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', and 'Sunday'. Again, the case of the strings is not important.


# Define a class Meetup with a constructor taking a month and a year
# and a method day(weekday, weekday).
# where weekday is one of: monday, tuesday, wednesday, etc.
# and weekday is first, second, third, fourth, fifth, last, or teenth



The details we need to keep in mind are as follows:

    April, June, September, and November have 30 days.
    February has 28 in most years, but 29 in leap years.
    All the other months have 31 days.
    The first day of the week of the month (DOWM) is always between the 1st and 7th of the month.
    The second DOWM is between the 8th and 14th of the month.
    The third DOWM is between the 15th and 21st of the month.
    The fourth DOWM is between the 22nd and 28th of the month.
    The fifth DOWM is between the 29th and 31st of the month.
    The last DOWM is between the 22nd and the 31st of the month depending on the number of days in the month.



    constructor
        Save the year and month
        Determine the last day of the month (28-31) (see hint above)

    Method: day
        Convert the weekday and weekday descriptor to lowercase.
        Calculate the first possible day of the month for the meetup.
        Calculate the last possible day of the month for the meetup.
        Search the range of possible days for the date that occurs on the desired day of the week
        Return a date object for the first matching day or a value that indicates that a meetup date couldn't be found.

d = Date.parse('3rd Feb 2001')
      #=> #<Date: 2001-02-03 ...>
d.year			#=> 2001
d.mon			#=> 2
d.mday			#=> 3
d.wday			#=> 6
d += 1			#=> #<Date: 2001-02-04 ...>
d.strftime('%a %d %b %Y')	#=> "Sun 04 Feb 2001"
=end


class Meetup

  POSSIBLE_DAYS = {
    'first' => (1..7).to_a,
    'second' => (8..14).to_a,
    'third' => (15..21).to_a,
    'fourth' => (22..28).to_a,
    'fifth' => (29..31).to_a,
    'last' => (22..31).to_a,
    'teenth' => (13..19).to_a
  }.freeze

  DAYS_WEEK = (0..6).to_a.zip(%w[sunday monday tuesday wednesday thursday friday saturday]).to_h.invert.freeze

  def initialize(year, month)
    @month = month
    @year = year
  end

  def day(weekday, schedule)
    day_range = POSSIBLE_DAYS[schedule.downcase]
    of_the_week = DAYS_WEEK[weekday.downcase]
    last_day_of_month = Date.new(@year, @month, -1).mday
    counter = day_range[0]
    meetup_day = Date.new(@year, @month, counter)

    loop do
      break if meetup_day.nil? || (meetup_day.wday == of_the_week && day_range.include?(meetup_day.mday))

      counter += 1
      meetup_day = counter > last_day_of_month ? nil : Date.civil(@year, @month, counter)
    end
    if schedule.downcase == 'last' && meetup_day.mday + 7 <= last_day_of_month
      [22, 23, 24].include?(meetup_day.mday) ? meetup_day = Date.civil(@year, @month, counter+7) : counter
    end
    meetup_day
  end
end

test = Meetup.new(2016, 6)

test1 = test.day('Thursday', 'last')

p test1
