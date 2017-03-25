module Keepachangelog
  class Parser
    attr_accessor :parsed_content

    def initialize(content = '')
      self.parsed_content = parse(content)
    end

    def self.load(filename = 'CHANGELOG.md')
      content = File.open(filename, &:read)
      new(content)
    end

    def self.parse(content)
      new(content)
    end

    def to_json
      parsed_content.to_json
    end

    def to_yaml
      parsed_content.to_yaml
    end

    def to_s
      parsed_content.to_s
    end

    private

    def parse(content)
      content = "\n" + clean(content).strip + "\n"
      anchors = extract_anchors! content
      versions = content.split(/\n\s*## /)[1..-1]
      versions.map { |v| parse_version v, anchors }
    end

    def clean(content)
      content.sub(/^.*?\n\s*## /, '## ')
    end

    def parse_version(content, anchors)
      header_pattern = /\[(?<name>.*)\]( - (?<date>\d\d\d\d-\d\d-\d\d))?/
      sections = content.split(/\n\s*### /)
      header = sections[0].match header_pattern
      {
        'version' => header[:name],
        'url' => get_url(header[:name], anchors),
        'date' => header[:date],
        'changes' => sections[1..-1].map { |s| parse_section s }.to_h
      }
    end

    def get_url(version, anchors)
      anchors.keys.include?(version) ? anchors[version] : nil
    end

    def parse_section(content)
      lines = content.split("\n")
      bullets = lines[1..-1]
                .select { |s| s.strip.start_with?('- ') }
                .map { |s| clean_bullet(s) }
      [lines[0], bullets]
    end

    def clean_bullet(string)
      string.strip.gsub(/^\s*- /, '').gsub(/\(.*#\d+\)\.?$/, '').strip
    end

    def extract_anchors!(content)
      anchor_pattern = /\n\s*\[(.*)\]: (.*)\s*\n/
      anchors = content.scan anchor_pattern
      cleaned_content = ''
      while cleaned_content.to_s != content.to_s
        cleaned_content = content.gsub anchor_pattern, "\n"
        content.replace(cleaned_content)
      end
      anchors.map { |x| [x[0], x[1]] }.to_h
    end
  end
end
