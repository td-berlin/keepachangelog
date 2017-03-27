Feature: List transformators

  Parse a changelog by running `keepachangelog parse` or just simply
  `keepachangelog`.

  Scenario: Running with command
    Given a file "changelog/1.0.0/1.yml" with:
      """
      ---
      title: Feature A
      type: New
      """
    When I successfully run `keepachangelog yaml`
    Then the output should contain:
      """
      {"versions":{"1.0.0":{"changes":{"New":["Feature A"]}}}}
      """
