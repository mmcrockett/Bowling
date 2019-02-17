require_relative 'bowling_exception'

class Bowl
  STRIKE = 'X'
  SPARE  = '/'
  MAX_PINS = 10
  VALID_VALUES = (0..9).to_a + [STRIKE, SPARE]

  def initialize(bowl)
    if (false == valid?(bowl))
      raise BowlingException.new("Invalid bowl value '#{bowl}'.")
    end

    @bowl  = bowl
    @value = nil
  end

  def to_s
    return "#{@bowl}"
  end

  def +(other)
    if (true == other.is_a?(Bowl))
      return self.pins + other.pins
    else
      return self.pins + other.to_i
    end
  end

  def reduce(other)
    @value = self.pins - other.pins
  end

  def pins
    if (false == @value.nil?)
      return @value
    elsif (false == mark?)
      return @bowl
    else
      return MAX_PINS
    end
  end

  def mark?
    return (true == strike?) || (true == spare?)
  end

  def spare?
    return (SPARE == @bowl)
  end

  def strike?
    return (STRIKE == @bowl)
  end

  private
  def valid?(v)
    return VALID_VALUES.include?(v)
  end
end
