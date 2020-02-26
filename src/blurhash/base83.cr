module Base83
  extend self

  CHARSET =
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~"

  def encode(io : IO, value : Int, length : Int) : Nil
    divisor = (83 ** length.to_f).to_u64
    unless value // divisor == 0
      raise ArgumentError.new "Invalid length: #{length}"
    end
    divisor //= 83
    (0...length).each do
      unless divisor > 0
        raise ArgumentError.new "Invalid length: #{length}"
      end
      digit = (value // divisor) % 83
      divisor //= 83
      io << CHARSET[digit]
    end
  end

  def encode(value : Int, length : Int) : String
    String.build { |io| encode(io, value, length) }
  end

  def decode(str : String) : Int64
    value = 0_i64
    str.each_char do |char|
      unless digit = CHARSET.index(char)
        raise ArgumentError.new "Invalid character: #{char.inspect}"
      end
      value = (value &* 83) + digit
    end
    value
  end
end
