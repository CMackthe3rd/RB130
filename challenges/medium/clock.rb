=begin
Create a clock that is independent of date.

You should be able to add minutes to and subtract minutes from the time represented by a given Clock object. Note that you should not mutate Clock objects when adding and subtracting minutes -- create a new Clock object.

Two clock objects that represent the same time should be equal to each other.

You may not use any built-in date or time functionality; just use arithmetic operations.
=end

class Clock
  DAY_IN_MINS = 1440

  def initialize(hours, minutes)
    @hours = hours
    @minutes = minutes
  end

  def self.at(hours, minutes = 0)
    Clock.new(hours, minutes)
  end

  def +(minutes)
    hour = @hours
    mins = @minutes
    add_mins = minutes

    if add_mins + mins > 59
      until add_mins < 60
        hour += 1
        add_mins -= 60
        hour = 0 if hour == 24
      end
    end
    mins += add_mins
    Clock.new(hour, mins)
    # up_from_midnight = time_since_midnight + minutes
    # up_from_midnight -= DAY_IN_MINS while up_from_midnight >= DAY_IN_MINS

    # adjust_time(up_from_midnight)
  end

  def -(minutes)
    #  methods that add and subtract from the current time. These methods accept a number of minutes to add or subtract as an argument.
    down_from_midnight = time_since_midnight - minutes
    down_from_midnight -= DAY_IN_MINS while down_from_midnight >= DAY_IN_MINS

    adjust_time(down_from_midnight)
  end

  def ==(other)
    #  a method that compares two clock objects for equality.
    to_s == other.to_s
  end

  def to_s
    #  a method that returns the clock's current time as a string.
    "#{hours_to_s}:#{minutes_to_s}"
  end

  private

  attr_reader :hours, :minutes

  def hours_to_s
    format('%02d', @hours)
  end

  def minutes_to_s
    format('%02d', @minutes)
  end

  def time_since_midnight
    total = 60 * hours + minutes
    total % DAY_IN_MINS
  end

  def adjust_time(since_midnight)
    hours, minutes = since_midnight.divmod(60)
    hours %= 24
    Clock.new(hours, minutes)
  end
end
