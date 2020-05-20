require "stumpy_png"
require "stumpy_jpeg"
require "./blurhash/*"

module Blurhash
  extend self

  alias RGB = {Float64, Float64, Float64}

  # Returns components as `{x, y}` tuple for valid strings, `nil` otherwise.
  def components(str : String) : {Int32, Int32}?
    return if str.empty?

    size_flag = Base83.decode(str[0..0]).to_i

    x_components = (size_flag % 9) + 1
    y_components = (size_flag // 9) + 1

    expected_size = 4 + 2 * x_components * y_components
    return unless str.size == expected_size

    {x_components, y_components}
  end

  # NOTE: At the moment only `png` and `jpg` file types are supported.
  def encode(x_components : Int, y_components : Int, path : Path) : String
    case ext = path.extension.lstrip('.').downcase.presence
    when "png"
      canvas = StumpyPNG.read(path.to_s)
    when "jpg", "jpeg"
      canvas = StumpyJPEG.read(path.to_s)
    when nil
      raise ArgumentError.new "Missing file extension"
    else
      raise ArgumentError.new "Extension #{ext.inspect} is not supported"
    end
    encode(x_components, y_components, canvas)
  end

  def encode(x_components : Int, y_components : Int, canvas : StumpyCore::Canvas) : String
    unless x_components.in?(1..8) && y_components.in?(1..8)
      raise ArgumentError.new "Component counts must be between 1 and 8"
    end

    # no pixels, no fun
    return "" if canvas.pixels.empty?

    unless canvas.pixels.size == canvas.width * canvas.height
      raise ArgumentError.new "Width and height must match the pixels size"
    end

    factors = [] of RGB

    (0...y_components).each do |y|
      (0...x_components).each do |x|
        factors << Utils.multiply_basis(x, y, canvas)
      end
    end

    dc = factors.first
    ac = factors[1..]?

    String.build do |buffer|
      size_flag = (x_components - 1) + (y_components - 1) * 9
      Base83.encode(buffer, size_flag, 1)

      if ac && !ac.empty?
        actual_maximum_value = ac.map(&.max).max
        quantised_maximum_value = (actual_maximum_value * 166 - 0.5).floor.clamp(0.0, 82.0).to_i
        maximum_value = (quantised_maximum_value + 1) / 166
        Base83.encode(buffer, quantised_maximum_value, 1)
      else
        maximum_value = 1.0
        Base83.encode(buffer, 0, 1)
      end

      Base83.encode(buffer, Utils.encode_dc(*dc), 4)
      ac.try &.each do |c|
        Base83.encode(buffer, Utils.encode_ac(*c, maximum_value), 2)
      end
    end
  end
end
