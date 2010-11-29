#!/usr/bin/ruby
require 'rubygems'
require 'sexp'
require File.expand_path(File.dirname(__FILE__) + '/step')
require File.expand_path(File.dirname(__FILE__) + '/scenario')

class FeatureParser

  def process_feature(file, instance)
    @tree = Sexp.new
    @scenarios = []

    File.read(file).each_with_index do |line,line_no|
      @line_no = line_no

      if line =~ /Scenario|Background/
        @scenario = Scenario.new
        @scenarios << @scenario
      else
        step_id = instance.line_matches(line,line_no,file)
        @scenario.add_step(step_id) if step_id
      end
    end

    return @scenarios
  end

end

