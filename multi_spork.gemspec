$:.unshift File.expand_path("../lib", __FILE__)
require "multi_spork/version"

Gem::Specification.new do |s|
  s.name = "multi_spork"
  s.version = MultiSpork::VERSION
  s.summary = "Run cucumber and rspec in parallel, and with spork"

  s.files = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.executables = ["multi_cuke"]

  s.add_dependency "spork", "~> 0.9.0"
  s.add_dependency "parallel"

  s.add_development_dependency "rspec", "~> 2.0"

  s.authors = ["Phuong Nguyen"]
  s.email = ["phuongnd08@gmail.com"]
  s.homepage = "http://github.com/phuongnd08/multi_spork/"
end
