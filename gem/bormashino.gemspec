# frozen_string_literal: true

require_relative 'lib/bormashino/version'

Gem::Specification.new do |spec|
  spec.name          = 'bormashino'
  spec.version       = Bormashino::VERSION
  spec.authors       = ['keyasuda']
  spec.email         = ['keyasuda@users.noreply.github.com']

  spec.summary       = 'The package to build SPAs with Ruby'
  spec.description   = <<-DESCRIPTION
  With "Bormaŝino" you can build SPAs written in Ruby powered by Ruby WebAssembly build and Sinatra (or other rack-based web application frameworks).
  DESCRIPTION
  spec.homepage      = 'https://github.com/keyasuda/bormashino'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2.0-preview1'

  spec.metadata['allowed_push_host'] = " Set to 'https://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/gem/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'json_pure', '~> 2.6', '>= 2.6.1'
  spec.add_dependency 'sinatra', '~> 2.2'
  spec.add_dependency 'ruby2_keywords', '0.0.4'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
