# frozen_string_literal: true

require_relative 'lib/dev_oops/version'

Gem::Specification.new do |spec|
  spec.name = 'dev_oops'
  spec.version = DevOops::VERSION
  spec.authors = ['Denis <Zaratan> Pasin']
  spec.email = ['zaratan@hey.com']

  spec.summary = 'Shell snipets manager'
  spec.description =
    'Shell snipets manager for those scripts you end up copy pasting over and over'
  spec.homepage = 'https://zaratan.fr'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage

  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
    end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'zeitwerk'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'prettier'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'solargraph'

  spec.post_install_message =
    'Run `dev_oops install` to create the base directory for dev_oops'
end
