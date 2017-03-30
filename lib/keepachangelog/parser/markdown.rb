module Keepachangelog
  # Parser for Markdown content
  class MarkdownParser < Parser
    # Parse raw markdown content
    def self.parse(content = '')
      new.parse(content)
    end

    # Parse a file with markdown content
    def self.load(filename = nil)
      filename ||= 'CHANGELOG.md'
      p = new
      p.parse File.open(filename, &:read)
      p
    end

    def parse(content)
      content = "\n" + content.strip + "\n"
      anchors = extract_anchors! content
      sections = content.split(/\n\s*## /)
      parse_meta anchors, sections[0]
      versions = sections[1..-1]
      parsed_content['versions'] = versions.map do |v|
        parse_version v, anchors
      end.to_h
      parsed_content
    end

    private

    def parse_meta(anchors, header)
      url = get_repo_url(anchors)
      title = extract_title!(header)
      intro = header.strip
      parsed_content['url'] = url if url
      parsed_content['intro'] = intro unless intro.to_s.empty?
      parsed_content['title'] = title if title
    end

    def extract_title!(text)
      title_pattern = /# (?<title>.*)/
      match = text.match(title_pattern)
      return nil unless match && match[:title]
      text.gsub!(title_pattern, '').strip!
      match[:title]
    end

    def parse_version(content, anchors)
      header_pattern = /\[?(?<name>[^\]]*)\]?( - (?<date>\d\d\d\d-\d\d-\d\d))?/
      sections = content.split(/\n\s*### /)
      header = sections[0].match header_pattern
      [header[:name].strip,
       {
         'url' => get_version_url(header[:name], anchors),
         'date' => header[:date],
         'changes' => sections[1..-1].map { |s| parse_section s }.to_h
       }]
    end

    def get_version_url(version, anchors)
      anchors.keys.include?(version) ? anchors[version] : nil
    end

    def get_repo_url(anchors)
      return nil unless anchors && anchors.values && anchors.values.first
      anchors.values.first.gsub(%r{/compare/.*}, '')
    end

    def parse_section(content)
      lines = content.split("\n")
      bullets = lines[1..-1]
                .select { |s| s.strip.start_with?('- ') }
                .map { |s| clean_bullet(s) }
      [lines[0], bullets]
    end

    def clean_bullet(string)
      string.strip.gsub(/^\s*- /, '').strip
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
