require "./spec_helper"

describe Blurhash do
  describe ".components" do
    it "returns a tuple with {x, y} components" do
      Blurhash.components("U~TSUA~q~q~q~q~q~q~q~q~q~q~q~q~q~q~q").should eq({4, 4})
      Blurhash.components("LFE.@D9F01_2%L%MIVD*9Goe-;WB").should eq({4, 3})
      Blurhash.components("00TSUA").should eq({1, 1})
    end

    it "returns nil for invalid strings" do
      Blurhash.components("foo").should be_nil
      Blurhash.components("").should be_nil
    end
  end

  describe ".encode" do
    it "properly encodes simple PNG images" do
      Blurhash.encode(4, 4, fixture_path("1x1.png"))
        .should eq("U~TSUA~q~q~q~q~q~q~q~q~q~q~q~q~q~q~q")

      Blurhash.encode(4, 3, fixture_path("white.png"))
        .should eq("L2TSUA~qfQ~q?bj[fQj[fQfQfQfQ")

      Blurhash.encode(4, 3, fixture_path("black.png"))
        .should eq("L00000fQfQfQfQfQfQfQfQfQfQfQ")
    end

    it "raises on unsupported file types" do
      expect_raises(ArgumentError, %(Extension "foo" is not supported)) do
        Blurhash.encode(1, 1, fixture_path("invalid.foo"))
      end
    end
  end
end
