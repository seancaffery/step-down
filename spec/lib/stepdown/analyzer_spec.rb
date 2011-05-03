require 'spec_helper'
require 'analyzer'
require 'reporter'
require 'html_reporter'
require 'text_reporter'

describe Stepdown::Analyzer do

  describe "selecting a reporter" do

    it "should return an HTML reporter" do
      analyzer = Stepdown::Analyzer.new('', '', 'html')
      reporter = analyzer.reporter('html',[],mock('step_collection'))
      reporter.should be_instance_of(Stepdown::HTMLReporter)
    end

    it "should return a text reporter" do
      analyzer = Stepdown::Analyzer.new('', '', 'text')
      reporter = analyzer.reporter('text',[],mock('step_collection'))
      reporter.should be_instance_of(Stepdown::TextReporter)
    end

    it "should return a quiet reporter" do
      analyzer = Stepdown::Analyzer.new('', '', 'quiet')
      reporter = analyzer.reporter('quiet',[],mock('step_collection'))
      reporter.should be_instance_of(Stepdown::Reporter)
    end

  end

end

