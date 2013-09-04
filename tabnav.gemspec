# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tabnav/version"

Gem::Specification.new do |s|
  s.name = %q{tabnav}
  s.version = Tabnav::VERSION

  s.authors = ["Alex Tomlins", "Unboxed Consulting"]
  s.email = %q{github@unboxedconsulting.com}
  s.homepage = %q{http://github.com/unboxed/tabnav}
  s.summary = %q{Rails helper for generating navbars}
  s.description = %q{Rails helper for generating navbars in a declarative manner}
  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.extra_rdoc_files = %w(LICENSE README.md)
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0"])
  s.add_development_dependency(%q<rails>, ["= 4.0.0"])
  s.add_development_dependency(%q<rspec>, ["~> 2.9.0"])
  s.add_development_dependency(%q<rspec-rails>, ["~> 2.9.0"])
end
