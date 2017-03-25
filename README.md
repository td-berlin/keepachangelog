# Keepachangelog

Ruby gem for parsing Changelogs based on the format described at
keepachangelog.com. The output can be either JSON or YAML.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keepachangelog'
```

And then execute:

    bundle

Or install it yourself as:

    gem install keepachangelog

## Usage

To dump a Changelog to JSON run the following command:

    keepachangelog --path=CHANGELOG.md --format=json

If you want to use the API from your own Ruby code:

```ruby
require 'keepachangelog'
parser = Keepachangelog::Parser.load('CHANGELOG.md')
puts parser.to_json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `grunt test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.
