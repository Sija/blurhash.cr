require "./blurhash"

def fail(message : String? = nil)
  if message = message.presence
    message = "Error: #{message}"
  end
  abort(message)
end

(ARGV.size == 3) ||
  abort "Usage: {#{PROGRAM_NAME}} <x_components> <y_components> <image_path>"

x_components, y_components, image_path = ARGV

x_components = x_components.to_i? || fail "<x_components> argument must be a number"
y_components = y_components.to_i? || fail "<y_components> argument must be a number"

path = Path[image_path].expand(home: true)

File.file?(path) ||
  fail "<image_path> argument must point to a valid file"

begin
  puts Blurhash.encode(
    x_components: x_components,
    y_components: y_components,
    path: path
  )
rescue ex : Exception
  fail(ex.message)
end
