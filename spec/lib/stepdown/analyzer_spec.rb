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
      reporter = @analyzer.reporter('html', double('stats'))
      reporter.should be_instance_of(Stepdown::HTMLReporter)
    end

    it "should return a text reporter" do
      reporter = @analyzer.reporter('text', double('stats'))
      reporter.should be_instance_of(Stepdown::TextReporter)
    end

    it "should return a quiet reporter" do
      reporter = @analyzer.reporter('quiet', double('stats'))
      reporter.should be_instance_of(Stepdown::Reporter)
    end

  end

  describe "#analyse" do
    it "should call the YamlWriter and Graph" do
      features = ["awesome.txt."]
      instance = double('instance', :step_collection => [])
      reporter = double('reporter')
      stats = double('stats')
      reporter.should_receive(:output_overview)

      @analyzer.should_receive(:instance).and_return(instance)
      @analyzer.should_receive(:feature_files).and_return(features)
      @analyzer.should_receive(:process_feature_files).with(features).and_return([])
      @analyzer.should_receive(:reporter).and_return(reporter)
      stats.should_receive(:generate)
      
      Stepdown::Statistics.stub(:new).with([], instance.step_collection).and_return(stats)
      Stepdown::YamlWriter.should_receive(:write).with(anything)
      Stepdown::FlotGraph.should_receive(:create_graph)

      @analyzer.analyze
    end
  end
  
  describe "#process_feature_files" do
    it "should instantiate a bunch of stuff" do
      double_listener = double(:listener)
      @analyzer.stub(:instance)
      Stepdown::FeatureParser.should_receive(:new).with(anything).and_return(double_listener)
      double_parser = double(:gherkin_parser)
      Gherkin::Parser::Parser.should_receive(:new).and_return(double_parser)
      File.stub(:read)
      double_parser.should_receive(:parse)
      double_listener.should_receive(:scenarios)
      @analyzer.process_feature_files(["blah.txt"])
    end
  end
end

