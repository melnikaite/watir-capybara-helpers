# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "watir-capybara-helpers"
  spec.version       = WatirCapybaraHelpers::VERSION
  spec.authors       = ["Eugene Melnikov"]
  spec.email         = ["melnikaite.melnikaite@gmail.com"]
  spec.summary       = "Creates aliases for existing capybara methods."
  spec.description   = "Make it possible to use most popular capybara methods in watir tests."
  spec.homepage      = "https://github.com/melnikaite/watir-capybara-helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"

  spec.add_runtime_dependency "watir-webdriver"
end
