class BowlingScore
  def initialize(rolls)
    @rolls = rolls.dup

    if (false == @rolls.is_a?(Array))
      raise BowlingException.new("!ERROR: Only array is expected got '#{@rolls.class}'.")
    end
  end

  def scores
    result = []

    @rolls.each do |roll|
    end

    return result
  end
end
