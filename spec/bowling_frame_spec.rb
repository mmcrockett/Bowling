require_relative '../bowling_frame'

describe BowlingFrame do
  FRAME = -> (data = [], n = 1) { b = BowlingFrame.new(n); data.each {|v| b << v}; return b }
  TENTH_FRAME = -> (data = []) { return FRAME.call(data, 10) }

  INVALID_FRAMES = [
    [Bowl::SPARE],
    [4, Bowl::STRIKE],
    [Bowl::STRIKE, Bowl::SPARE],
    [4, 4, 4],
    [4, 4, Bowl::SPARE],
    [4, 4, Bowl::STRIKE],
    [4, Bowl::SPARE, Bowl::SPARE],
    [Bowl::STRIKE, 4, Bowl::STRIKE],
    [Bowl::STRIKE, Bowl::SPARE, 4],
    [Bowl::STRIKE, Bowl::STRIKE, Bowl::SPARE]
  ]

  COMPLETE_FRAMES_BOTH = [
    [4, 4]
  ]

  INCOMPLETE_FRAMES_BOTH = [
    [],
    [4]
  ]

  COMPLETE_FRAMES = [
    [Bowl::STRIKE],
    [4, Bowl::SPARE]
  ]

  COMPLETE_TENTH_FRAMES = [
    [4, Bowl::SPARE, 4],
    [4, Bowl::SPARE, Bowl::STRIKE],
    [Bowl::STRIKE, 4, 4],
    [Bowl::STRIKE, 4, Bowl::SPARE],
    [Bowl::STRIKE, Bowl::STRIKE, Bowl::STRIKE],
    [Bowl::STRIKE, Bowl::STRIKE, 4]
  ]

  INCOMPLETE_TENTH_FRAMES = [
    [Bowl::STRIKE, Bowl::STRIKE],
    [Bowl::STRIKE, 4],
  ]

  it "should fail frame numbers less than 1" do
    expect { BowlingFrame.new(0) }.to raise_error(BowlingException, /Frame is expected to be/)
  end

  it "should fail frame numbers greater than 10" do
    expect { BowlingFrame.new(11) }.to raise_error(BowlingException, /Frame is expected to be/)
  end

  it "should fail if pins is greater than 9 with no mark" do
    expect { FRAME.call << 5 << 5 }.to raise_error(BowlingException, /More than nine pins with no mark/)
  end

  INVALID_FRAMES.each do |frame|
    it "should fail invalid #{frame}" do
      expect { FRAME.call(frame) }.to raise_error(BowlingException)
      expect { TENTH_FRAME.call(frame) }.to raise_error(BowlingException)
    end
  end

  COMPLETE_FRAMES_BOTH.each do |frame|
    it "should show complete for finished #{frame}" do
      expect(FRAME.call(frame).complete?).to eq(true)
      expect(TENTH_FRAME.call(frame).complete?).to eq(true)
    end
  end

  it "should show incomplete for unfinished frames" do
    INCOMPLETE_FRAMES_BOTH.each do |frame|
      expect(FRAME.call(frame).complete?).to eq(false)
      expect(TENTH_FRAME.call(frame).complete?).to eq(false)
    end
  end

  describe "regular frames" do
    it "should fail on valid tenth frames" do
      COMPLETE_TENTH_FRAMES.each do |frame|
        expect { FRAME.call(frame) }.to raise_error(BowlingException)
      end
    end

    it "should fail on incomplete tenth frames" do
      INCOMPLETE_TENTH_FRAMES.each do |frame|
        expect { FRAME.call(frame) }.to raise_error(BowlingException)
      end
    end

    it "should be complete for finished regular frames" do
      COMPLETE_FRAMES.each do |frame|
        expect(FRAME.call(frame).complete?).to eq(true)
      end
    end
  end

  describe "tenth frame" do
    it "should fail if pins is greater than 9 with no mark" do
      expect { TENTH_FRAME.call << 5 << 5 << 5 }.to raise_error(BowlingException, /More than nine pins with no mark/)
    end

    it "should be incomplete for finished regular frames" do
      COMPLETE_FRAMES.each do |frame|
        expect(TENTH_FRAME.call(frame).complete?).to eq(false)
      end
    end

    it "should be incomplete for unfinished tenth frames" do
      INCOMPLETE_TENTH_FRAMES.each do |frame|
        expect(TENTH_FRAME.call(frame).complete?).to eq(false)
      end
    end

    it "should be complete for finished tenth frames" do
      COMPLETE_TENTH_FRAMES.each do |frame|
        expect(TENTH_FRAME.call(frame).complete?).to eq(true)
      end
    end

    it "should not be complete for unfinished tenth frames" do
      INCOMPLETE_TENTH_FRAMES.each do |frame|
        expect(TENTH_FRAME.call(frame).complete?).to eq(false)
      end
    end

    it "should not be complete for finished regular frames" do
      COMPLETE_FRAMES.each do |frame|
        expect(TENTH_FRAME.call(frame).complete?).to eq(false)
      end
    end
  end

  it "should delineate the tenth frame" do
    expect(TENTH_FRAME.call.tenth?).to eq(true)
    expect(FRAME.call.tenth?).to eq(false)
  end

  it "should fail a total greater than 9" do
    expect { FRAME.call << 5 << 5 }.to raise_error(BowlingException, /More than nine pins with no mark/)
  end

  describe "scoring" do
    describe "for unifinished frames" do
      it "should nil for unfinished frames" do
        INCOMPLETE_FRAMES_BOTH.each do |frame|
          expect(FRAME.call(frame).score).to be_nil
          expect(TENTH_FRAME.call(frame).score).to be_nil
        end
      end

      describe "in the tenth" do
        it "should be nil for finished regular frames" do
          COMPLETE_FRAMES.each do |frame|
            expect(TENTH_FRAME.call(frame).score).to be_nil
          end
        end

        it "should be nil for unfinished tenth frames" do
          INCOMPLETE_TENTH_FRAMES.each do |frame|
            expect(TENTH_FRAME.call(frame).score).to be_nil
          end
        end
      end
    end

    describe "for finished frames" do
      describe "tenth frame" do
        it "should always have a sum" do
          expectations = [14, 20, 18, 20, 30, 24, 8]

          (COMPLETE_TENTH_FRAMES + COMPLETE_FRAMES_BOTH).each_with_index do |frame, i|
            expect(TENTH_FRAME.call(frame).score).to eq(expectations[i])
          end
        end
      end

      it "should always have a sum for non mark frame" do
        COMPLETE_FRAMES_BOTH.each do |frame|
          expect(FRAME.call(frame).score).to be 8
        end
      end

      it "should not have a sum for strike frames with incomplete next two bowls" do
        COMPLETE_FRAMES.each do |frame|
          if (Bowl::STRIKE == frame.last)
            expect(FRAME.call(frame).score).to be_nil
            expect(FRAME.call(frame).score([3])).to be_nil
            expect(FRAME.call(frame).score(['X'])).to be_nil
          end
        end
      end

      it "should not have a sum for spare frames with incomplete next one bowls" do
        COMPLETE_FRAMES.each do |frame|
          if (Bowl::SPARE == frame.last)
            expect(FRAME.call(frame).score).to be_nil
          end
        end
      end

      it "should always have a sum for strike frames two next bowls" do
        COMPLETE_FRAMES.each do |frame|
          if (Bowl::STRIKE == frame.last)
            expect(FRAME.call(frame).score([3,4,'X'])).to eq(17)
            expect(FRAME.call(frame).score([2, '/'])).to eq(20)
            expect(FRAME.call(frame).score(['X', 'X'])).to eq(30)
          end
        end
      end

      it "should always have a sum for spare with next bowl" do
        COMPLETE_FRAMES.each do |frame|
          if (Bowl::SPARE == frame.last)
            expect(FRAME.call(frame).score([3,4,'X'])).to eq(13)
            expect(FRAME.call(frame).score(['X'])).to eq(20)
          end
        end
      end
    end
  end
end
