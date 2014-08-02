# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clerk/version'

Gem::Specification.new do |spec|
  spec.name          = "clerkapp"
  spec.version       = Clerk::VERSION
  spec.authors       = ["Mateusz Juraszek", "Tomasz Mazur"]
  spec.email         = ["mateusz@webtigers.eu", "defkode@gmail.com"]
  spec.summary       = %q{Provides a simple ruby wrapper around the Clerkapp API}
  spec.description   = %q{Ruby gem for heroku addon "clerk". Clerk is an add-on that enables you programatically fill in field-values for an active PDF form, letting you easily generate a new PDF based on those field-values, which can then be printed or stored.}
  spec.homepage      = "https://github.com/meceo/clerkapp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",  "~> 1.5"
  spec.add_development_dependency "rake",     "~> 10.2"
  spec.add_development_dependency "minitest", "~> 5.3"
  spec.add_development_dependency "vcr",      "~> 2.9"
  spec.add_development_dependency "pry",      "~> 0.9"

  spec.add_dependency "faraday", '~> 0.9'
end
