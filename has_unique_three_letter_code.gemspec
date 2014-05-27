# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_unique_three_letter_code/version'

Gem::Specification.new do |spec|
  spec.name          = "has_unique_three_letter_code"
  spec.version       = HasUniqueThreeLetterCode::VERSION
  spec.authors       = ["Isaac Betesh"]
  spec.email         = ["iybetesh@gmail.com"]
  spec.description   = "Assigns a case-insensitive unique three-letter code to each record in a scope, based loosely on some other attribute of the record"
  spec.summary       = `cat README.md`
  spec.homepage      = "https://github.com/betesh/has_unique_three_letter_code/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "sqlite3"

  spec.add_runtime_dependency "activerecord", ">= 4.0.0"
end
