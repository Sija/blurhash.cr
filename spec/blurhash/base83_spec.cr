require "../spec_helper"

describe Base83 do
  describe ".encode" do
    it "properly encodes single digits" do
      (0...83).each do |i|
        (0..3).each do |j|
          Base83.encode(i, 1 + j).should eq(("0" * j) + Base83::CHARSET[i..i])
        end
      end
    end

    it "properly encodes valid values" do
      data = {
        {0, 0, ""},
        {6888, 4, "00~~"},
        {163902429697, 6, "foobar"},
        {100, 2, "1H"},
      }
      data.each do |value, length, result|
        Base83.encode(value, length).should eq(result)
      end
    end

    it "raises on invalid values" do
      data = {
        {84, 1},
        {-1597651267176502418, 16},
        {163902429697, 10},
      }
      data.each do |value, length|
        expect_raises(Exception) do
          Base83.encode(value, length)
        end
      end
    end
  end

  describe ".decode" do
    it "properly decodes single digits" do
      (0...83).each do |i|
        (0..3).each do |j|
          Base83.decode(("0" * j) + Base83::CHARSET[i..i]).should eq(i)
        end
      end
    end

    it "properly decodes valid values" do
      data = {
        {"", 0},
        {"00~~", 6888},
        {"foobar", 163902429697},
        {"LFE.@D9F01_2%L%MIVD*9Goe-;WB", -1597651267176502418},
      }
      data.each do |value, result|
        Base83.decode(value).should eq(result)
      end
    end

    it "raises on invalid characters" do
      expect_raises(ArgumentError, "Invalid character") do
        Base83.decode("LFE.@D9F01_2%L%MIVD*9Goe-;Wµ")
      end
    end
  end
end
