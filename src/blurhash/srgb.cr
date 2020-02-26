module Blurhash::SRGB
  extend self

  def to_linear(value : Int) : Float64
    v = value / 255
    if v <= 0.04045
      v / 12.92
    else
      ((v + 0.055) / 1.055) ** 2.4
    end
  end

  def from_linear(value : Float) : Int32
    v = {0.0, {1.0, value}.min}.max
    if v <= 0.0031308
      v = v * 12.92 * 255 + 0.5
    else
      v = (1.055 * (v ** (1 / 2.4)) - 0.055) * 255 + 0.5
    end
    v.to_i
  end
end
