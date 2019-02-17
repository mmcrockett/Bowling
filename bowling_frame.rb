require_relative 'bowling_exception'
require_relative 'bowl'

class BowlingFrame
  def initialize(frame)
    @frame = frame
    @bowls = []

    if (false == (1..10).to_a.include?(@frame))
      raise BowlingException.new("Frame is expected to be an integer between 1 and 10 representing the frame number.")
    end
  end

  def <<(bowl)
    if (false == bowl.is_a?(Bowl))
      bowl = Bowl.new(bowl)
    end

    validate(bowl)

    if (true == bowl.spare?)
      bowl.reduce(@bowls.last)
    end

    @bowls << bowl

    return self
  end

  def score(next_scores = [])
    result = nil

    if (true == self.complete?)
      if (false == @bowls.last.mark?) || (true == self.tenth?)
        result = 0

        @bowls.each {|bowl| result += bowl.pins}
      elsif (true == self.strike?) && (next_scores.size >= 2)
        result = Bowl::MAX_PINS
        scores = []
        
        next_scores[0, 2].each do |score|
          bowl = Bowl.new(score)

          if (true == bowl.spare?)
            bowl.reduce(scores[-1])
          end

          scores << bowl
        end

        scores.each do |score|
          result += score.pins
        end
      elsif (true == self.spare?) && (next_scores.size >= 1)
        result = Bowl::MAX_PINS + Bowl.new(next_scores.first).pins
      end
    end

    return result
  end

  def n_bowls
    return @bowls.size
  end

  def bowls
    return @bowls.freeze
  end

  def complete?
    if (true == @bowls.empty?)
      return false
    elsif (true == self.tenth?)
      return (3 == self.n_bowls) ||
        ((2 == self.n_bowls) && (false == @bowls.any? {|bowl| bowl.mark?}))
    else
      return (true == @bowls.last.mark?) || (2 == self.n_bowls)
    end
  end

  def tenth?
    return (10 == @frame)
  end

  def strike?
    return (0 != self.n_bowls) && (true == @bowls.last.strike?)
  end

  def spare?
    return (0 != self.n_bowls) && (true == @bowls.last.spare?)
  end

  def to_s
    return "#{@bowls * ' '}"
  end

  private
  def validate(v)
    if (true == self.complete?)
      raise BowlingException.new("Frame is already complete '#{@bowls}'.")
    elsif (true == v.spare?)
      if (0 == self.n_bowls) || (true == @bowls.last.mark?)
        raise BowlingException.new("Spare must follow a number '#{@bowls}'.")
      end
    elsif (true == v.strike?)
      if (0 != self.n_bowls) && (false == @bowls.last.mark?)
        raise BowlingException.new("Strike cannot follow number '#{@bowls}'.")
      end
    else
      if (0 != self.n_bowls) && (false == @bowls.last.mark?) && (9 < (v.pins + @bowls.last.pins))
        raise BowlingException.new("More than nine pins with no mark.")
      end
    end
  end

  def get_next_scores(next_frames, n)
    scores = []

    next_frames.each do |next_frame|
      next_frame.bowls.each do |bowl|
        return scores if (scores.size >= n)

        scores << bowl
      end
    end

    return scores
  end
end
