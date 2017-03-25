Feature: List transformators

  Parse a changelog by running `keepachangelog parse` or just simply
  `keepachangelog`.

  Scenario: Running with command
    Given a file "CHANGELOG.md" with:
      """
      ## [Unreleased]
      ### New
      - Feature A
      """
    When I successfully run `keepachangelog parse`
    Then the output should contain:
      """
      [{"version":"Unreleased","url":null,"date":null,"changes":{"New":["Feature A"]}}]
      """

  Scenario: Running without command
    Given a file "CHANGELOG.md" with:
      """
      ## [Unreleased]
      ### New
      - Feature A
      """
    When I successfully run `keepachangelog`
    Then the output should contain:
      """
      [{"version":"Unreleased","url":null,"date":null,"changes":{"New":["Feature A"]}}]
      """

  Scenario: Changelog has a non-default filename
    Given a file "HISTORY.md" with:
      """
      ## [Unreleased]
      ### New
      - Feature A
      """
    When I successfully run `keepachangelog --path=HISTORY.md`
    Then the output should contain:
      """
      [{"version":"Unreleased","url":null,"date":null,"changes":{"New":["Feature A"]}}]
      """