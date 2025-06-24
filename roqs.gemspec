# frozen_string_literal: true

require_relative "lib/roqs/version"

Gem::Specification.new do |spec|
  spec.name = "roqs"
  spec.version = Roqs::VERSION
  spec.authors = ["Chris"]
  spec.email = ["chris@antrapol.com"]

  spec.summary = "Ruby wrapper for liboqs"
  spec.description = "Ruby wrapper for liboqs via direct shared library method invocation. The wrapper is pretty stable since it is direct method invocation from shared library. Any upgrade to the liboqs, after compiled to a shred library, roqs can immediately utilize the upgraded library without any modification."
  spec.homepage = "https://github.com/chrisliaw/roqs"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chrisliaw/roqs"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "teLogger", "~> 0.2"
  spec.add_dependency "toolrack", "~> 0.23"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_development_dependency 'release-gem', "~> 0.3.3" 
end
