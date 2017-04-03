Feature: Parse changelogs

  Parse a changelog by running `keepachangelog parse` or just simply
  `keepachangelog`.

  Scenario: Convert from Markdown to JSON
    Given a file "CHANGELOG.md" with:
      """
      # My Changes
      Some intro goes here.
      ## [Unreleased]
      ### New
      - Feature A
      """
    When I successfully run `keepachangelog --from md --to json --in CHANGELOG.md`
    Then the output should contain:
      """
      {"versions":{"Unreleased":{"url":null,"date":null,"changes":{"New":["Feature A"]}}},"intro":"Some intro goes here.","title":"My Changes"}
      """

  Scenario: Convert from YAML files to Markdown
    Given a file "changelog/1.0.0/1.yml" with:
      """
      ---
      title: Feature A
      type: New
      """
    When I successfully run `keepachangelog --from yaml --to md`
    Then the output should contain:
      """
      # Change log
      All notable changes to this project will be documented in this file.
      
      The format is based on [Keep a Changelog](http://keepachangelog.com/)
      and this project adheres to [Semantic Versioning](http://semver.org/).
      """
    And the output should contain "## 1.0.0 - "
    And the output should contain:
      """
      ### New
      - Feature A.
      """

  Scenario: Convert from Markdown to YAML files
    Given a file "CHANGELOG.md" with:
      """
      # My Changes
      Some intro goes here.
      ## [Unreleased]
      ### New
      - Feature A
      """
    When I successfully run `keepachangelog --from md --to yaml --in CHANGELOG.md --out test`
    Then the file "test/Unreleased/feature-a.yaml" should contain:
      """
      ---
      title: Feature A
      type: New
      """