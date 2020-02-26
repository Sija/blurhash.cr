require "../spec_helper"

describe Blurhash::Utils do
  it ".sign_pow" do
    data = {
      {-2.0, 4, -16.0},
      {2.0, 4, 16.0},
    }
    data.each do |value, exponent, result|
      Blurhash::Utils.sign_pow(value, exponent).should eq(result)
    end
  end
end
