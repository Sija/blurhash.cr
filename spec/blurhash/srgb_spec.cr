require "../spec_helper"

describe Blurhash::SRGB do
  it ".to_linear" do
    data = {
      {0, 0.0},
      {255, 1.0},
      {188, 0.5},
    }
    data.each do |value, result|
      Blurhash::SRGB.to_linear(value).should be_close(result, 0.05)
    end
  end

  it ".from_linear" do
    data = {
      {0.0, 0},
      {1.0, 255},
      {0.5, 188},
    }
    data.each do |value, result|
      Blurhash::SRGB.from_linear(value).should eq(result)
    end
  end
end
