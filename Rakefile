
require './step_down'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'logger'

desc "Analyse cucumber steps and features"
task :analyse do
  step_dir = ''
  feature_dir = ''
  parser = StepDown.new(step_dir, feature_dir)
  parser.analyse
end
