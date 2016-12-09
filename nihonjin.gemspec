# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nihonjin/version'

Gem::Specification.new do |spec|
  spec.name          = "nihonjin"
  spec.version       = Nihonjin::VERSION
  spec.authors       = ["gazayas"]
  spec.email         = ["g-zayas@hotmail.com"]

  spec.summary       = "handle Japanese<=>English letter strings with ease"
  spec.description   = "Ruby has the NKF.nkf() method, but the options are unclear by just looking at them, so this gem has methods like hiragana() so you know what you're changing your strings to"
  spec.homepage      = "https://github.com/gazayas/nihonjin"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "http://rubygems.org/gems/nihonjin"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
