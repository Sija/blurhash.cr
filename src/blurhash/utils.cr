module Blurhash::Utils
  extend self

  def multiply_basis(x_component : Int, y_component : Int, canvas : StumpyCore::Canvas) : RGB
    r, g, b = 0.0, 0.0, 0.0

    width = canvas.width
    height = canvas.height

    (0...width).each do |x|
      (0...height).each do |y|
        basis = Math.cos(Math::PI * x_component * x / width) *
                Math.cos(Math::PI * y_component * y / height)
        color = canvas[x, y].to_rgb8
        color.tap do |rgb|
          r += basis * SRGB.to_linear(rgb[0])
          g += basis * SRGB.to_linear(rgb[1])
          b += basis * SRGB.to_linear(rgb[2])
        end
      end
    end

    normalisation = (x_component.zero? && x_component.zero?) ? 1.0 : 2.0
    scale = normalisation / (width * height)

    RGB.new(r * scale, g * scale, b * scale)
  end

  def encode_dc(r : Float, g : Float, b : Float) : Int32
    rounded_r = SRGB.from_linear(r)
    rounded_g = SRGB.from_linear(g)
    rounded_b = SRGB.from_linear(b)
    (rounded_r << 16) + (rounded_g << 8) + rounded_b
  end

  def encode_ac(r : Float, g : Float, b : Float, maximum_value : Float) : Int32
    quant_r = (sign_pow(r / maximum_value, 0.5) * 9 + 9.5).floor.clamp(0.0, 18.0).to_i
    quant_g = (sign_pow(g / maximum_value, 0.5) * 9 + 9.5).floor.clamp(0.0, 18.0).to_i
    quant_b = (sign_pow(b / maximum_value, 0.5) * 9 + 9.5).floor.clamp(0.0, 18.0).to_i
    (quant_r * 19 * 19) + (quant_g * 19) + quant_b
  end

  def sign_pow(value : Number, exponent : Number)
    (value.abs ** exponent) * value.sign
  end
end
