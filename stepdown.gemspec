
Gem::Specification.new do |s|
  s.name = "stepdown"
  s.version = "0.1"
  s.platform = Gem::Platform::RUBY
  s.authors = "Sean Caffery"
  s.email = "sean@lineonpoint.com"
  s.summary = "Analysis tool for Cucumber features"
  s.description = "Step down allows you to see where your most used Cucumber steps are and will help in refactoring"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "stepdown"

  s.add_dependency('haml', '>= 2.0.0')
  s.files = `git ls-files`.split("\n")
  s.executables = ["stepdown"]
  s.default_executable = "stepdown"
  s.require_paths = ["lib"]
end
