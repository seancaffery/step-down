$:.push File.expand_path("../lib", __FILE__)
require "stepdown/version"

Gem::Specification.new do |s|
  s.name = "stepdown"
  s.version = Stepdown::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.authors = ["Sean Caffery"]
  s.email = ["sean@lineonpoint.com"]
  s.summary = "Static analysis tool for Cucumber features"
  s.homepage = "http://stepdown.lineonpoint.com"
  s.description = "Stepdown allows you to see where your most used Cucumber steps are, your unused steps and how they are clustered"
  s.license = "MIT"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "stepdown"

  s.add_dependency('gherkin', '~> 2.3')
  s.add_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rspec', "~> 3.4")
  s.add_development_dependency('sass', "~> 3.1")
  s.add_development_dependency('rake', '~> 10.0')
  s.add_development_dependency('pry', '~> 0.10')
  s.add_development_dependency('bump', '~> 0.5')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.default_executable = "stepdown"
end
