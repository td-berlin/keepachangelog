# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keepachangelog/version'
git_files = `git ls-files -z`.split("\x0")
gem_files = git_files.reject { |f| f.match(%r{^(spec|features|fixtures)/}) }
gem_files = git_files.reject { |f| f.match('.gitlab-ci.yml') }
gem_files = git_files.reject { |f| f.match('.gitignore') }
gem_files = git_files.reject { |f| f.match('CONTRIBUTING.md') }
gem_files = git_files.reject { |f| f.match('Gruntfile.js') }
gem_files = git_files.reject { |f| f.match('packages.json') }

Gem::Specification.new do |spec|
  spec.name          = 'keepachangelog'
  spec.version       = Keepachangelog.version
  spec.authors       = ['Basalt AB']
  spec.email         = %w(christoffer.brodd-reijer@basalt.se)
  spec.licenses      = ['Nonstandard']
  spec.summary       = 'Parser for changelogs based on keepachangelog.com'
  spec.description   = 'Tool for parsing changelogs that are based on the '\
                       'keepachangelog.com standard. Changelogs can be dumped '\
                       'to JSON or YAML.'
  spec.homepage      = 'http://www.basalt.se'
  spec.files         = gem_files
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'simplecov', '~> 0.14'
  spec.add_development_dependency 'aruba', '~> 0.14'
  spec.add_runtime_dependency     'thor', '~> 0.19'
  spec.add_runtime_dependency     'json', '~> 2.0'
end
