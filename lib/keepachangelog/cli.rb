require 'keepachangelog'
require 'thor'

module Keepachangelog
  class CLI < Thor
    include Thor::Actions

    def self.shell
      Thor::Base.shell.new
    end

    package_name 'Keepachangelog'

    desc 'version', 'Show current version'
    long_desc 'Show the version of the tool'
    def version
      require 'keepachangelog/version'
      shell.say Keepachangelog.version
    end

    desc 'markdown', 'Parse a changelog in markdown'
    option :format, type: :string,
                    desc: 'The output format',
                    default: 'json',
                    banner: 'json|yaml',
                    aliases: '-f'
    option :path, type: :string,
                  desc: 'Path to the Changelog file',
                  default: 'CHANGELOG.md',
                  aliases: '-p'
    def markdown
      require 'keepachangelog/parser/markdown'
      p = MarkdownParser.load(options[:path])
      shell.say p.send("to_#{options[:format]}")
    end

    desc 'yaml', 'Parse a folder of YAML files'
    option :format, type: :string,
                    desc: 'The output format',
                    default: 'json',
                    banner: 'json|yaml',
                    aliases: '-f'
    option :path, type: :string,
                  desc: 'Path to the yaml folder',
                  default: 'changelog',
                  aliases: '-p'
    def yaml
      require 'keepachangelog/parser/yaml'
      p = YamlParser.load(options[:path])
      shell.say p.send("to_#{options[:format]}")
    end

    default_task :markdown
  end
end
