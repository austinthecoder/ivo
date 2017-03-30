# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ivo/version'

Gem::Specification.new do |spec|
  spec.name          = "ivo"
  spec.version       = Ivo::VERSION
  spec.authors       = ["Austin Schneider"]
  spec.email         = ["me@austinschneider.com"]

  spec.summary       = "Library for creating immutable value objects (IVO)"
  spec.homepage      = "https://github.com/austinthecoder/ivo"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
