require_relative 'bowling_frame'
require 'highline'

class Alley
  def initialize(bowls = [])
    @bowls = bowls
  end

  def <<(bowl)
    @bowls << bowl
  end

  def last
    return @bowls.last
  end

  def scores
    results    = []
    last_frame = nil
    frame_number = 1

    @bowls.each_with_index do |bowl, i|
      if (10 < frame_number)
        raise BowlingException.new("Too many bowls it seems.")
      end

      if (true == last_frame.nil?) || (true == last_frame.complete?)
        last_frame = BowlingFrame.new(frame_number)
      end

      if (false == last_frame.complete?)
        last_frame << bowl
      end

      if (true == last_frame.complete?)
        results << last_frame.score(@bowls[i + 1..-1])
        frame_number += 1
      end
    end

    if (false == last_frame.nil?) && (false == last_frame.complete?)
      results << last_frame.score()
    end

    return results
  end

  def pop
    @bowls.pop
  end

  def total
    sum = 0

    self.scores.each do |score|
      sum += score
    end

    return sum
  end
end

options = {}
option_parser = OptionParser.new

option_parser.new do |opt|
  opt.banner = "Usage: Alley.rb [options]"
  opt.on('-g', '--game', 'Go bowling.') { |o| options[:game] = true }
end.parse!

alley = Alley.new

if (true == options[:game])
  cli   = HighLine.new
  bowls = Bowl::VALID_VALUES.dup
  bowls << Bowl::STRIKE << Bowl::SPARE
  rand  = Random.new
  finished = false

  while (false == finished)
    answer = cli.ask("Enter a number: ", Integer)
    found = false

    while (false == found)
      index  = (answer + Random.new.rand(bowls.size)) % bowls.size
      alley << bowls[index]

      begin
        alley.scores
        found = true
      rescue BowlingException => e
        if (true == e.message.include?("Too many bowls"))
          alley.pop
          puts "Great game, your score was #{alley.total}"
          found = true
          finished = true
        else
          alley.pop
        end
      end
    end

    if (false == finished)
      puts "You bowled a #{alley.last}!"
      puts "#{alley.scores}"

      bowls << alley.last
    end
  end
end
