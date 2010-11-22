#!/usr/bin/ruby
require 'rubygems'
require 'sexp'
require File.expand_path(File.dirname(__FILE__) + '/step')
require File.expand_path(File.dirname(__FILE__) + '/scenario')

class CukeInstance
  def initialize
    @steps = []
  end
  def steps
    @steps
  end

  def Given(regex,&block)
    define_step(regex,&block)
  end
  def When(regex,&block)
    define_step(regex,&block)
  end
  def Then(regex,&block)
    define_step(regex,&block)
  end

  def define_step(regex,&block)
    @steps << regex
  end

  def method_missing(*args)
    #nothing
  end

  def require(*args)
    # do nothing
  end

  def line_matches(line,line_no,file)
    stripped_line = line.strip.gsub(/^(And|Given|When|Then) (.*)$/,'\2')

    @steps.each_with_index do |regex,i|
      match = regex.match(stripped_line)
      if match
        s_exp = Sexp.new(:call,nil,"method_#{i}".to_sym, Sexp.new(:arglist,*(match.captures.collect {|str| Sexp.new(:str,str)})))
        s_exp.line = line_no
        s_exp.file = file
        return steps[i]
      end
    end

    return nil
  end

  def steps
    return @step_definitions if @step_definitions
    @step_definitions = []
    @steps.each_with_index do |regex, i|
      @step_definitions << Step.new(i, regex)
    end
    @step_definitions
  end

end

class Flay

  def process_feature file, instance
    @file = file

    @tree = Sexp.new
    @current_node = @tree
    @current_node << :block
    @scenarios = []

    File.read(file).each_with_index do |line,line_no|
      @line_no = line_no

      if line =~ /Scenario|Background/
        @current_node = @tree
        @current_node << s(:iter,s(:call,nil,:scen_defn,s(:arglist)),nil)
        @current_node = @current_node.last
        @scenario = Scenario.new
        @scenarios << @scenario
      else
        step_id = instance.line_matches(line,line_no,file)
        @current_node << step_id if step_id
        @scenario.add_step(step_id) if step_id
      end
    end

    return @scenarios
  end

  def s(*args)
    s_exp = Sexp.new(*args)
    s_exp.file = @file
    s_exp.line = @line_no
    s_exp
  end
end

