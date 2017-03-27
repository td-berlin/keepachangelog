module Keepachangelog
  class MarkdownPrinter
    attr_accessor :options
    attr_accessor :versions

    def initialize(versions, options = {})
      self.options = options
      self.versions = versions
    end

    def to_s
      [
        "# #{options[:title] || default_title}",
        clean_intro(options[:intro]) || default_intro,
        '',
        versions.reverse_each.map do |k, v|
          version(k, v)
        end,
        anchors
      ].flatten.join("\n")
    end

    private

    def clean_intro(text)
      text.to_s.strip.gsub("\n", "\n\n")
    end

    def version(header, content)
      [
        version_header(header),
        content['changes'].map { |k, v| section(k, v) }
      ]
    end

    def section(header, content)
      [
        "### #{header}",
        content.map { |c| change(c) },
        ''
      ]
    end

    def anchors
      v = versions.keys.sort.reverse
      (0..v.length - 1).map { |i| anchor(v, i) }
    end

    def anchor(v, i)
      from_v = i == v.length - 1 ? first_commit : v[i + 1]
      to_v = v[i] == 'Unreleased' ? 'HEAD' : v[i]
      "[#{v[i]}]: #{options[:url]}/compare/#{from_v}..#{to_v}"
    end

    def change(content)
      "- #{content}"
    end

    def default_title
      'Change log'
    end

    def default_intro
      "All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/)."
    end

    def first_commit
      `git rev-parse --short $(git rev-list --max-parents=0 HEAD) 2>/dev/null`
        .strip
    end

    def version_date(version)
      date = `git log -1 --format=%aI #{version} 2>/dev/null`.strip
      DateTime.parse(date).strftime('%Y-%m-%d')
    rescue
      nil
    end

    def version_header(version)
      header = version
      header = "[#{header}]" if options[:url]
      date = version_date(version)
      header += " - #{date}" if date
      "## #{header}"
    end
  end
end
