# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clerkapp/version'

Gem::Specification.new do |spec|
  spec.name          = "clerkapp"
  spec.version       = Clerkapp::VERSION
  spec.authors       = ["Mateusz Juraszek"]
  spec.email         = ["mateusz@webtigers.eu"]
  spec.summary       = %q{Provides a simple ruby wrapper around the Clerkapp API}
  spec.description   = %q{Provides a simple ruby wrapper around the Clerkapp API}
  spec.homepage      = "https://www.clerkapp.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday"
end
