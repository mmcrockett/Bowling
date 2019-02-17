require_relative '../bowl'

describe Bowl do
  it "should fail non integer value" do
    expect { Bowl.new(1.3) }.to raise_error(BowlingException, /Invalid bowl value/)
  end

  it "should fail invalid string value" do
    expect { Bowl.new('x') }.to raise_error(BowlingException, /Invalid bowl value/)
  end

  it "should return the pin count" do
    expect(Bowl.new(Bowl::STRIKE).pins).to eq(10)
    expect(Bowl.new(Bowl::SPARE).pins).to eq(10)

    (0..9).each do |v|
      expect(Bowl.new(v).pins).to eq(v)
    end
  end

  it "should return the pin count less other pins" do
    spare = Bowl.new(Bowl::SPARE)
    other = Bowl.new(3)

    spare.reduce(other)

    expect(spare.pins).to eq(7)
  end
end
