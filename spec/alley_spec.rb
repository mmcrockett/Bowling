require_relative '../alley'

describe Alley do
  SAMPLE_DATA = [
    [Array.new(10 + 2, 'X'), Array.new(10, 30)],
    [[4, 5, 'X', 8, 1], [9, 19, 9]],
    [Array.new(10, [0, '/']).flatten, Array.new(9, 10) + [nil]],
    [Array.new(10, [0, '/']).flatten + [5], Array.new(9, 10) + [15]],
    [Array.new(10, [0, 8]).flatten, Array.new(10, 8)],
    [Array.new(5, [2, '/', 'X']).flatten, Array.new(9, 20) + [nil]],
    [Array.new(5, [2, '/', 'X']).flatten + ['X'], Array.new(9, 20) + [nil]],
    [Array.new(5, [2, '/', 'X']).flatten + [4, 3], Array.new(9, 20) + [17]],
  ]

  it "should fail if too many bowls are given" do
    data = Array.new(10 * 2 + 1, 1)
    expect { Alley.new(data).scores }.to raise_error(BowlingException, /Too many bowls it seems/)
  end

  it "should return empty array on empty input" do
    expect(Alley.new.scores).to eq []
  end

  it "should return nil for unfinished frames" do
    expect(Alley.new([4, 5, 'X', 8]).scores).to eq [9, nil, nil]
  end

  SAMPLE_DATA.each do |sample|
    it "should return correct values for #{sample.first}" do
      expect(Alley.new(sample.first).scores).to eq sample.last
    end
  end

  it "should allow pushing of bowls" do
    alley = Alley.new

    20.times do |i|
      alley << 1
      expected = Array.new((i + 1)/2, 2)

      if (true == i.even?)
        expected << nil
      end

      expect(alley.scores).to eq expected
    end
  end
end
