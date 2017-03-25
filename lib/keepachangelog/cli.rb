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

    desc '<options> parse', 'Parse a changelog'
    option :format, type: :string,
                    desc: 'The output format',
                    default: 'json',
                    banner: 'json|yaml',
                    aliases: '-f'
    option :path, type: :string,
                  desc: 'Path to the changelog file',
                  default: 'CHANGELOG.md',
                  aliases: '-p'
    def parse
      require 'keepachangelog/parser'
      p = Parser.load(options[:path])
      shell.say p.send("to_#{options[:format]}")
    end

    default_task :parse
  end
end
