require 'spec_helper'
require 'analyzer'
require 'reporter'
require 'html_reporter'
require 'text_reporter'
require 'stepdown'

describe Stepdown::Analyzer do

  before(:each) do
    @analyzer = Stepdown::Analyzer.new('','','html')
    Stepdown.quiet = true
  end

  describe "selecting a reporter" do

    it "should return an HTML reporter" do
      reporter = @analyzer.reporter('html', mock('stats'))
      reporter.should be_instance_of(Stepdown::HTMLReporter)
    end

    it "should return a text reporter" do
      reporter = @analyzer.reporter('text', mock('stats'))
      reporter.should be_instance_of(Stepdown::TextReporter)
    end

    it "should return a quiet reporter" do
      reporter = @analyzer.reporter('quiet', mock('stats'))
      reporter.should be_instance_of(Stepdown::Reporter)
    end

  end

  describe "#analyse" do
    it "should call the YamlWriter and Graph" do
      features = ["awesome.txt."]
      instance = mock('instance', :step_collection => [])
      reporter = mock('reporter')
      stats = mock('stats')
      reporter.should_receive(:output_overview)

      @analyzer.should_receive(:instance).and_return(instance)
      @analyzer.should_receive(:feature_files).and_return(features)
      @analyzer.should_receive(:process_feature_files).with(features).and_return([])
      @analyzer.should_receive(:reporter).and_return(reporter)
      stats.should_receive(:generate)
      
      Stepdown::Statistics.stub!(:new).with([], instance.step_collection).and_return(stats)
      Stepdown::YamlWriter.should_receive(:write).with(anything)
      Stepdown::Graph.should_receive(:create_graph)

      @analyzer.analyse
    end
  end
  
  describe "#process_feature_files" do
    it "should instantiate a bunch of stuff" do
      mock_listener = mock(:listener)
      @analyzer.stub!(:instance)
      Stepdown::FeatureParser.should_receive(:new).with(anything).and_return(mock_listener)
      mock_parser = mock(:gherkin_parser)
      Gherkin::Parser::Parser.should_receive(:new).and_return(mock_parser)
      File.stub!(:read)
      mock_parser.should_receive(:parse)
      mock_listener.should_receive(:scenarios)
      @analyzer.process_feature_files(["blah.txt"])
    end
  end
end

