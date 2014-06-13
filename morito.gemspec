# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'morito/version'

Gem::Specification.new do |spec|
  spec.name          = "morito"
  spec.version       = Morito::VERSION
  spec.authors       = ["negipo"]
  spec.email         = ["negipo@gmail.com"]
  spec.summary       = %q{A client to handle robots.txt}
  spec.homepage      = "https://github.com/negipo/morito"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency "faraday"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
