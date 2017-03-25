Feature: Show version

  To show the version of the gem run `keepachangelog version`.

  Scenario: Running `keepachangelog version`
    When I successfully run `keepachangelog version`
    Then the output should match /\d+\.\d+\.\d+/