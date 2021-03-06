
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "senju/version"

Gem::Specification.new do |spec|
  spec.name          = "senju"
  spec.version       = Senju::VERSION
  spec.authors       = ["Akira SUENAMI"]
  spec.email         = ["a.suenami@gmail.com"]

  spec.summary       = %q{Transparent wrapper of some task management and collabolation tools.}
  spec.description   = %q{You can get your todos from some tools.}
  spec.homepage      = "https://github.com/mi2zq/senju"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", "~> 4.9"
  spec.add_dependency "gitlab", "~> 4.5"
  spec.add_dependency "ruby-trello", "~> 2.1"

  spec.add_dependency "awesome_print"
  spec.add_dependency "colorize"
  spec.add_dependency "tty-markdown"
  spec.add_dependency "rumoji"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
