Feature: Show help

  You can get general help by running `keepachangelog help`. To get more
  information about a specific command run `keepachangelog help [COMMAND]`.

  Scenario: Getting general help
    When I successfully run `keepachangelog help`
    Then the output should contain "Keepachangelog commands"

  Scenario: Getting help about a command
    When I successfully run `keepachangelog help parse`
    Then the output should contain "Usage"