require "./blurhash"

unless ARGV.size == 3
  abort "Usage: #{PROGRAM_NAME} x_components y_components image_path"
end

x_components, y_components, image_path = ARGV

begin
  puts Blurhash.encode(
    x_components: x_components.to_i,
    y_components: y_components.to_i,
    path: Path[image_path].expand(home: true)
  )
rescue e : Exception
  abort e.message
end
