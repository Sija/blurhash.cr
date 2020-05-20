require "./blurhash"

(ARGV.size == 3) ||
  abort "Usage: #{PROGRAM_NAME} <x_components> <y_components> <image_path>"

x_components, y_components, image_path = ARGV

x_components = x_components.to_i? || abort "<x_components> argument must be a number"
y_components = y_components.to_i? || abort "<y_components> argument must be a number"

path = Path[image_path].expand(home: true)

File.file?(path) ||
  abort "<image_path> argument must point to a valid file"

begin
  puts Blurhash.encode(
    x_components: x_components,
    y_components: y_components,
    path: path
  )
rescue e : Exception
  abort e.message
end
