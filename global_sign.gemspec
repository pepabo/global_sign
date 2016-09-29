# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'global_sign/version'

Gem::Specification.new do |spec|
  spec.name          = "global_sign"
  spec.version       = GlobalSign::VERSION
  spec.authors       = ["ku00"]
  spec.email         = ["skentaro36@gmail.com"]

  spec.summary       = %q{A Ruby interface to the GlobalSign API.}
  spec.description   = %q{A Ruby interface to the GlobalSign API.}
  spec.homepage      = "https://github.com/pepabo/global_sign"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "builder"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency 'pry-byebug'
end
