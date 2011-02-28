#!/usr/bin/ruby
require 'rubygems'

require File.expand_path(File.dirname(__FILE__) + '/step')
require File.expand_path(File.dirname(__FILE__) + '/scenario')

class FeatureParser

  def process_feature(file, instance)
    @scenarios = []

    File.read(file).split("\n").each do |line|

      if line =~ /Scenario|Background/
        @scenario = Scenario.new
        @scenarios << @scenario
      else
        step_id = instance.line_matches(line)
        @scenario.add_step(step_id) if step_id
      end
    end

    return @scenarios
  end

end

