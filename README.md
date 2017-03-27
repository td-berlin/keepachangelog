# Keepachangelog

Ruby gem for parsing Changelogs based on the format described at
keepachangelog.com.

The parser can read either a Markdown file or a folder structure with
YAML-files.

The output can be Markdown, YAML or JSON.

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

### Command line

#### Markdown input
To dump a Changelog to JSON run the following command:

    keepachangelog --path CHANGELOG.md --format json

#### YAML input
You can also express your changelog in YAML files inside a folder structure
where each version is its own folder containing each change in a YAML-file.

Here's an example of a folder structure:
```
changelog
├── 0.1.0
│   └── 1-first-merge-request.yaml
├── 0.2.0
│   └── 3-another-cool-mr.yaml
├── 0.3.0
│   ├── 8-fixing-some-stuff.yaml
│   └── 9-add-new-feature.yaml
└── unreleased
    └── 11-minor-patch.yaml
```

Each YAML-file should be in the following format:

```yaml
---
title: The ability to perform Foo while Bar is active
merge_request: 11
issue: 42
author: @chbr
type: New
```


- `title`: A single sentence without punctiation that describes the change
- `merge_request`: The ID of the MR or PR (optional)
- `issue`: The ID of the issue (optional)
- `author`: The author of the change (optional)
- `type`: The type of change, for example *New*, *Changed*, *Fixed*,
  *Removed* or *Security*.

To turn this into a Markdown document, simply run `keepachangelog yaml -f md`

You can add meta data to your changelog in the file `meta.yaml` like so:

```yaml
---
title: My Change Log
intro: This is my change log and I am using a cool gem to generate it.
url: https://git.example.com/group/project
```

The following meta data is read:
- `title`: The title at the top of the Change log
- `intro`: A text shown directly below the title
- `url`: A URL to the git repository, used to generate links for versions
  that follows the format *<url>/compare/FROM..TO*

### From Ruby code

If you want to use the API from your own Ruby code:

```ruby
require 'keepachangelog'
parser = Keepachangelog::MarkdownParser.load('CHANGELOG.md')
puts parser.to_json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `grunt test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.
