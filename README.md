# blurhash.cr [![Build Status](https://travis-ci.com/Sija/blurhash.cr.svg?branch=master)](https://travis-ci.com/Sija/blurhash.cr) [![Releases](https://img.shields.io/github/release/Sija/blurhash.cr.svg)](https://github.com/Sija/blurhash.cr/releases) [![License](https://img.shields.io/github/license/Sija/blurhash.cr.svg)](https://github.com/Sija/blurhash.cr/blob/master/LICENSE)

A pure Crystal implementation of [Blurhash](https://github.com/woltapp/blurhash). The API is stable, however the hashing function in either direction may not be.

Blurhash is an algorithm written by [Dag Ågren](https://github.com/DagAgren) for [Wolt (woltapp/blurhash)](https://github.com/woltapp/blurhash) that encodes an image into a short (~20-30 byte) ASCII string. When you decode the string back into an image, you get a gradient of colors that represent the original image. This can be useful for scenarios where you want an image placeholder before loading, or even to censor the contents of an image [à la Mastodon](https://blog.joinmastodon.org/2019/05/improving-support-for-adult-content-on-mastodon/).

Currently supports `PNG` and `JPEG` file types.

## Installation

### Library

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     blurhash:
       github: Sija/blurhash.cr
   ```

2. Run `shards install`

### CLI

1. Run `shards build --release`

## Usage

### Library

```crystal
require "blurhash"

puts Blurhash.encode(
  x_components: 4,
  y_components: 3,
  path: Path["foo.png"]
)
```

### CLI

```console
$ ./bin/blurhash 4 3 foo.png
```

## Contributing

1. Fork it (<https://github.com/Sija/blurhash.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sijawusz Pur Rahnama](https://github.com/Sija) - creator and maintainer
