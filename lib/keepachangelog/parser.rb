module Keepachangelog
  class Parser
    attr_accessor :parsed_content

    def initialize
      self.parsed_content = {}
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
  end
end
