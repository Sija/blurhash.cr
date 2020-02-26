require "spec"
require "../src/blurhash"

def fixture_path(*parts : String) : Path
  Path[__DIR__, "fixtures", *parts].expand
end
