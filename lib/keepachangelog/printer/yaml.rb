require 'fileutils'

module Keepachangelog
  class YamlPrinter < Printer
    attr_accessor :changelog

    def initialize(changelog)
      self.changelog = changelog
    end

    def write(path)
      FileUtils.mkdir_p(path)
      write_meta File.join(path, 'meta.yaml')
      write_versions path, changelog['versions']
    end

    private

    def write_meta(path)
      meta = {}
      %w[url title intro].each do |key|
        meta[key] = changelog[key] unless changelog[key].to_s.empty?
      end
      File.write(path, meta.to_yaml)
    end

    def write_versions(path, versions)
      versions.each do |version, data|
        folder = File.join(path, version)
        FileUtils.mkdir_p folder
        write_changes folder, data['changes']
      end
    end

    def write_changes(path, changes)
      changes.each do |section, lines|
        lines.each do |line|
          change = parse_line(line)
          change['type'] = section
          write_change path, change
        end
      end
    end

    def write_change(folder, change)
      fname = change['title'].gsub(/\W/, ' ').strip.tr(' ', '-').downcase
      fname = "#{change['issue']}-#{fname}" if change['issue']
      fname = "#{change['merge_request']}-#{fname}" if change['merge_request']
      path = create_unique_file(folder, fname + '.yaml')
      File.write(path, change.to_yaml)
    end

    def parse_line(line)
      issue = extract_field! line, /\s*\(#(?<issue>\d+)\)\s*/, :issue
      mr = extract_field! line, /\s*\(!(?<mr>\d+)\)\s*/, :mr
      author = extract_field! line, /\s*\((?<author>.*@.*)\)\s*/, :author
      data = { 'title' => line }
      data['author'] = author if author
      data['merge_request'] = mr.to_i if mr
      data['issue'] = issue.to_i if issue
      data
    end

    def extract_field!(line, pattern, name)
      match = line.match(pattern)
      return nil unless match && match[name]
      line.gsub!(pattern, '').strip
      match[name]
    end

    def create_unique_file(folder, filename)
      if File.exist? File.join(folder, filename)
        randstr = SecureRandom.hex(3)
        filename = "#{randstr}-#{filename}"
      end
      File.join(folder, filename)
    end
  end
end
