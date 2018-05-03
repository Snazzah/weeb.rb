<div align=center>
  <h1>Weeb.rb</h1>
</div>
[![Gem Version](https://img.shields.io/gem/v/weeb.svg)]()
[![Gem Downloads](https://img.shields.io/gem/dt/weeb.svg)]() [![Travis](https://img.shields.io/travis/Snazzah/weeb.rb/master.svg)]()
[![Inline docs](http://inch-ci.org/github/Snazzah/weeb.rb.svg?branch=master&style=shields)](http://inch-ci.org/github/Snazzah/weeb.rb)
[![Docs](https://img.shields.io/badge/view-docs-FACE00.svg)](http://www.rubydoc.info/gems/weeb)

A wrapper gem for the [weeb.sh](https://weeb.sh) API.

## Dependencies
* [rest-client](https://github.com/rest-client/rest-client)

## Installation:
Just

    gem install weeb

## Examples
```ruby
require 'weeb'
client = WeebSh::Client.new('Wolke #######', 'weeb/1.0.0/example')
# You can also set the API url by setting 'api_url'

# Using WeebSh::Client ties all interfaces together, but you can also use them seperately:
standalone_interface = WeebSh::Toph('Wolke #######', 'weeb/1.0.0/toph_example')
```
Toph
```ruby
client.toph.list # [#<WeebSh::WeebImage, ...>]
client.toph.random(type: 'discord_memes') # #<WeebSh::WeebImage @url="https://cdn.weeb.sh/images/rkDQ-DVs-.png" @type="discord_memes" @nsfw=false>
```

# Contributing

Please run rubocop while testing. That's all I ask. *(and common sense)*

# License

The contents of this repository are licensed under the MIT license. A copy of the MIT license can be found in [LICENSE.md](LICENSE.md).
