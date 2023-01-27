class Triangle
  def initialize(l, w, h)
    @sides = [l, w, h]
    raise ArgumentError, 'Not a valid triangle' unless valid_triangle?(@sides)
  end

  def valid_triangle?(sides)
    sides = sides.dup.sort
    max = sides.pop
    sides.sum > max && sides.none?(0)
  end

  def kind
    case @sides.uniq.size
    when 1 then 'equilateral'
    when 2 then 'isosceles'
    when 3 then 'scalene'
    end
  end
end