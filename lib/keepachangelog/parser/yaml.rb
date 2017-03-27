module Keepachangelog
  # Parser for YAML content
  #
  # The YAML files describing the Changelog are expected to be in a folder
  # structure where each version is its own folder and each Merge Request
  # or Pull Request is in its own YAML-file.
  #
  # ```
  # changelog
  # ├── 0.1.0
  # │   └── 1-first-merge-request.yaml
  # ├── 0.2.0
  # │   └── 3-another-cool-mr.yaml
  # ├── 0.3.0
  # │   ├── 8-fixing-some-stuff.yaml
  # │   └── 9-add-new-feature.yaml
  # └── unreleased
  #     └── 11-minor-patch.yaml
  # ```
  #
  # Each YAML file is expected to be in the following format:
  #
  # ```yaml
  # ---
  # title: The ability to perform Foo while Bar is active
  # merge_request: 11
  # issue: 42
  # author: @chbr
  # type: New
  # ```
  #
  # - `title` is a single sentence without punctiation that describes the
  #   change
  # - `merge_request` is the ID of the MR or PR (optional)
  # - `issue` is the ID of the issue (optional)
  # - `author` is the username of the author (optional)
  # - `type` is the type of change, for example *New*, *Changed*, *Fixed*,
  #   *Removed* or *Security*.
  class YamlParser < Parser
    # Parse raw yaml content of a single file
    def self.parse(content, version = 'unreleased')
      new.parse(content, version)
    end

    # Parse a folder with YAML files
    def self.load(path = 'changelog')
      p = new
      p.load(path)
      p
    end

    # Parse raw yaml content of a single file
    def parse(content, version)
      initialize_version version
      yaml = YAML.safe_load content
      return {} unless yaml
      add_change yaml, version
    end

    # Parse a folder with YAML files
    def load(path = 'changelog')
      Dir.glob("#{path}/*").each { |f| parse_version(f) }
    end

    private

    def add_change(yaml, version)
      parsed_content[version]['changes'][yaml['type']] ||= []
      parsed_content[version]['changes'][yaml['type']] << generate_line(yaml)
      parsed_content
    end

    def parse_version(folder)
      version = File.basename(folder)
      initialize_version version
      files = Dir.glob("#{folder}/**/*.yaml") +
              Dir.glob("#{folder}/**/*.yml")
      files.sort.each { |f| parse_file(f, version) }
    end

    def parse_file(filename, version)
      parse File.open(filename, &:read), version
    end

    def generate_line(yaml)
      line = yaml['title']
      line += " (!#{yaml['merge_request']})" if yaml['merge_request']
      line += " (##{yaml['issue']})" if yaml['issue']
      line += " (#{yaml['author']})" if yaml['author']
      line
    end

    def initialize_version(version)
      parsed_content[version] = { 'changes' => {} }
    end
  end
end
