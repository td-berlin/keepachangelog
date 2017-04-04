module Keepachangelog
  class MarkdownPrinter < Printer
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
        parse_versions(versions),
        anchors
      ].flatten.join("\n")
    end

    private

    def parse_versions(versions)
      versions.sort { |a, b| compare_versions(a[0], b[0]) }
              .reverse_each.map { |k, v| version(k, v) }
    end

    def compare_versions(a, b)
      if Gem::Version.correct?(a) && Gem::Version.correct?(b)
        Gem::Version.new(a) <=> Gem::Version.new(b)
      elsif Gem::Version.correct?(a)
        -1
      elsif Gem::Version.correct?(b)
        1
      else
        a <=> b
      end
    end

    def clean_intro(text)
      return nil unless text
      text.to_s.strip
    end

    def version(header, content)
      [
        version_header(header, content['date']),
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
      return nil unless options[:url]
      v = versions.keys.sort.reverse
      (0..v.length - 1).map { |i| anchor(v, i) }
    end

    def anchor(v, i)
      from_v = i == v.length - 1 ? first_commit : v[i + 1]
      to_v = Gem::Version.correct?(v[i]) ? v[i] : 'HEAD'
      "[#{v[i]}]: #{options[:url]}/compare/#{from_v}...#{to_v}"
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

    def version_header(version, date)
      header = version
      header = "[#{header}]" if options[:url]
      header += " - #{date}" if date
      "## #{header}"
    end
  end
end
