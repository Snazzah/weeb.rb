<div align=center>
  <h1>Weeb.rb</h1>
</div>

![Gem Version](https://img.shields.io/gem/v/weeb.svg)
![Gem Downloads](https://img.shields.io/gem/dt/weeb.svg)
![Travis](https://img.shields.io/travis/Snazzah/weeb.rb/master.svg)
[![Inline docs](http://inch-ci.org/github/Snazzah/weeb.rb.svg?branch=master&style=shields)](http://inch-ci.org/github/Snazzah/weeb.rb)
[![Docs](https://img.shields.io/badge/view-docs-FACE00.svg)](https://www.rubydoc.info/github/Snazzah/weeb.rb/master)

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
standalone_interface = WeebSh::Toph.new('Wolke #######', 'weeb/1.0.0/toph_example')
```
Toph
```ruby
client.toph.list # [#<WeebSh::WeebImage, ...>]
client.toph.random(type: 'discord_memes') # #<WeebSh::WeebImage @url="https://cdn.weeb.sh/images/rkDQ-DVs-.png" @type="discord_memes" @nsfw=false>
```

# Contributing

You should always run these two things in terminal *(and use common sense!)*:

    rubocop
    inch suggest

# License

The contents of this repository are licensed under the MIT license. A copy of the MIT license can be found in [LICENSE.md](LICENSE.md).
