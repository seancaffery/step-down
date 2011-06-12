require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
end

RSpec::Core::RakeTask.new(:coverage) do |t|
  t.fail_on_error = false
  t.rcov_opts = %w{ --exclude gems\/,spec\/,features\/}
  t.rcov = true
end

task :default => :spec
