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
      shell.say Keepachangelog.version
    end

    desc 'parse', 'Parse a changelog'
    option :from, type: :string,
                  desc: 'The input format',
                  default: 'md',
                  banner: 'yaml|md',
                  aliases: '-f'
    option :to, type: :string,
                desc: 'The output format',
                default: 'json',
                banner: 'json|yaml|md',
                aliases: '-t'
    option :in, type: :string,
                desc: 'Path to the input file/folder',
                aliases: '-i'
    option :out, type: :string,
                 desc: 'Path to the output file/folder',
                 aliases: '-o'
    def parse
      case options[:from].to_sym
      when :md then parse_markdown
      when :yaml then parse_yaml
      else
        shell.error "Unknown input format #{options[:from]}"
        exit 1
      end
    end

    default_task :parse

    private

    def parse_markdown
      parser = MarkdownParser.load(options[:in])
      print parser
    end

    def parse_yaml
      parser = YamlParser.load(options[:in])
      print parser
    end

    # rubocop:disable Metrics/AbcSize
    def print(parser)
      case options[:to].to_sym
      when :json
        shell.say parser.to_json
      when :s, :string
        shell.say parser.to_s
      when :md, :markdown
        shell.say parser.to_md
      when :yaml, :yml
        out = options[:out] || 'changelog'
        parser.to_yaml(out)
        shell.say "Finished writing changelog to '#{out}'"
      else
        shell.error "Unknown output format #{options[:to]}"
        exit 2
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
