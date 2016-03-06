# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ldfwrapper/version"
require 'bundler'

Gem::Specification.new do |s|
  s.name        = "ldfwrapper"
  s.version     = Ldfwrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steven Anderson", "Chris Beer", "Justin Coyne", "Bess Sadler"]
  s.email       = ["hydra-tech@googlegroups.com"]
  s.homepage    = "https://github.com/boston-library/ldf-wrapper"
  s.summary     = %q{Convenience tasks for working with various linked data backends.}
  s.description = %q{Spin up a jetty instance (e.g., the one at https://github.com/boston-library/ldf-jetty) and wrap test in it. This lets us run tests against a real copy of marmotta and blazegraph.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
  s.license       = 'APACHE2'

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "logger"
  s.add_dependency "childprocess"
  s.add_dependency "i18n"
  s.add_dependency "activesupport", ">=3.0.0"
  s.add_dependency 'rubyzip', "~> 1.0"

  s.add_development_dependency "rspec", '~> 3.2'
  s.add_development_dependency "rspec-its"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'

  s.add_development_dependency 'yard'
end

