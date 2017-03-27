require 'keepachangelog/markdown_printer'

module Keepachangelog
  class Parser
    attr_accessor :parsed_content

    def initialize
      self.parsed_content = { 'versions' => {} }
    end

    # Changelog in JSON format
    #
    # Example:
    # ```json
    # {"1.0.0": { "changes": { "New": ["Feature A"] } } }
    # ```
    def to_json
      parsed_content.to_json
    end

    # Changelog in YAML format
    #
    # Example:
    # ```yaml
    # ---
    # 0.1.0:
    #   changes:
    #     New:
    #     - Feature A
    # ```
    def to_yaml
      parsed_content.to_yaml
    end

    # Changelog as a Ruby string
    #
    # Example:
    # ```ruby
    # {"0.1.0"=>{"changes"=>{"New"=>["Feature A"]}}
    # ```
    def to_s
      parsed_content.to_s
    end

    # Changelog as Markdown
    def to_md
      md = MarkdownPrinter.new(parsed_content['versions'],
                               title: parsed_content['title'],
                               intro: parsed_content['intro'],
                               url: parsed_content['url'])
      md.to_s
    end
  end
end
