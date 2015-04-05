# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rowling/version'

Gem::Specification.new do |spec|
  spec.name          = "rowling"
  spec.version       = Rowling::VERSION
  spec.authors       = ["Sonja Peterson"]
  spec.email         = ["sonja.peterson@gmail.com"]
  spec.summary       = "Wrapper for USA Today Bestsellers API."
  spec.description   = "A simple Ruby wrapper for accessing USA Today bestseller data."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest-reporters"
end
