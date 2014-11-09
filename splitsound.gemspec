# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'splitsound/version'

Gem::Specification.new do |spec|
  spec.name          = "splitsound"
  spec.version       = Splitsound::VERSION
  spec.authors       = ["Chad Bailey"]
  spec.email         = ["chadbailey@gmail.com"]
  spec.summary       = %q{Split a single video file into multiple audio files.}
  spec.description   = %q{Split a single video file into multiple audio files.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency "streamio-ffmpeg"
end
