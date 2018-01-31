# Change log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.6.0] - 2018-01-31
### Added
- Ability to sort sections.
- Changes are now sorted alphabetically.
- Support for Ruby 2.5.

## [0.5.3] - 2018-01-31
### Fixed
- Move project into the Basalt group on GitLab.com.
- Print the output folder when generating YAML to default location.

## [0.5.2] - 2018-01-31
### Fixed
- Fix incorrect previous version in URL in Markdown output. (#15)

## [0.5.1] - 2018-01-31
### Added
- The YAML parser now fetches the date when a version was created.

### Fixed
- Handle arbitrary name for unreleased version when creating URL in Markdown.

## [0.5.0] - 2018-01-31
### Added
- Allow any name for unreleased versions. (#9)

### Changed
- Date of a version in generated Markdown now defaults to current date instead of blank. (#11)

### Fixed
- Lines that end with special characters will no longer result in a crash. (#10)

## [0.4.1] - 2018-01-31
### Fixed
- Deploy job in CI will no longer be skipped even though it should run. (#8)

## [0.4.0] - 2018-01-31
### Added
- Ability to output changelog to yaml file structure. (!9)
- The code is pushed into a public repo at gitlab.com.

### Fixed
- Sort versions in reverse numerical order in Markdown output. (#7)

## [0.3.1] - 2018-01-31
### Fixed
- Remove duplicates in Changelog for this project. (#6)

## [0.3.0] - 2018-01-31
### Added
- Documentation on how to add metadata. (#4)

### Fixed
- Do not display anchors when URL is missing. (#3)
- YAML parser can now read multiple changes in a version. (#2)

## [0.2.1] - 2018-01-31
### Fixed
- Fix documentation formatting for YAML parser.

## [0.2.0] - 2018-01-31
### Added
- Ability to print in Markdown.
- Ability to read YAML files.

## [0.1.0] - 2018-01-31
### Added
- Ability to convert Changelog to JSON.
- Ability to convert Changelog to YAML.
- Tool for reading Changelog in Markdown format.

[0.6.0]: https://gitlab.com/basalt/keepachangelog/compare/0.5.3...0.6.0
[0.5.3]: https://gitlab.com/basalt/keepachangelog/compare/0.5.2...0.5.3
[0.5.2]: https://gitlab.com/basalt/keepachangelog/compare/0.5.1...0.5.2
[0.5.1]: https://gitlab.com/basalt/keepachangelog/compare/0.5.0...0.5.1
[0.5.0]: https://gitlab.com/basalt/keepachangelog/compare/0.4.1...0.5.0
[0.4.1]: https://gitlab.com/basalt/keepachangelog/compare/0.4.0...0.4.1
[0.4.0]: https://gitlab.com/basalt/keepachangelog/compare/0.3.1...0.4.0
[0.3.1]: https://gitlab.com/basalt/keepachangelog/compare/0.3.0...0.3.1
[0.3.0]: https://gitlab.com/basalt/keepachangelog/compare/0.2.1...0.3.0
[0.2.1]: https://gitlab.com/basalt/keepachangelog/compare/0.2.0...0.2.1
[0.2.0]: https://gitlab.com/basalt/keepachangelog/compare/0.1.0...0.2.0
[0.1.0]: https://gitlab.com/basalt/keepachangelog/compare/77986bc...0.1.0
