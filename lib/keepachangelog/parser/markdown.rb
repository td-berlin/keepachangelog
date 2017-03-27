module Keepachangelog
  # Parser for Markdown content
  class MarkdownParser < Parser
    # Parse raw markdown content
    def self.parse(content = '')
      new.parse(content)
    end

    # Parse a file with markdown content
    def self.load(filename = 'CHANGELOG.md')
      parse File.open(filename, &:read)
    end

    def parse(content)
      content = "\n" + clean(content).strip + "\n"
      anchors = extract_anchors! content
      versions = content.split(/\n\s*## /)[1..-1]
      {
        'versions' => versions.map { |v| parse_version v, anchors }.to_h
      }
    end

    private

    def clean(content)
      content.sub(/^.*?\n\s*## /, '## ')
    end

    def parse_version(content, anchors)
      header_pattern = /\[(?<name>.*)\]( - (?<date>\d\d\d\d-\d\d-\d\d))?/
      sections = content.split(/\n\s*### /)
      header = sections[0].match header_pattern
      [header[:name],
       {
         'url' => get_url(header[:name], anchors),
         'date' => header[:date],
         'changes' => sections[1..-1].map { |s| parse_section s }.to_h
       }]
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
